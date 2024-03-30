#
# This file contains the actual Vault server definitions
#

# Template for creating Vault nodes
locals {
  lb_scheme         = upper(var.load_balancing_scheme)
  use_internal_lb   = local.lb_scheme == "INTERNAL"
  use_external_lb   = local.lb_scheme == "EXTERNAL"
  vault_tls_bucket  = var.vault_tls_bucket != "" ? var.vault_tls_bucket : var.vault_storage_bucket
  default_kms_key   = "projects/${var.project_id}/locations/${var.region}/keyRings/${var.kms_keyring}/cryptoKeys/${var.kms_crypto_key}"
  vault_tls_kms_key = var.vault_tls_kms_key != "" ? var.vault_tls_kms_key : local.default_kms_key
  api_addr          = var.domain != "" ? "https://${var.domain}:${var.vault_port}" : "https://${local.lb_ip}:${var.vault_port}"
  host_project      = var.host_project_id != "" ? var.host_project_id : var.project_id
  lb_ip             = local.use_external_lb ? google_compute_forwarding_rule.external[0].ip_address : var.ip_address
  # LB and Autohealing health checks have different behavior.  The load
  # balancer shouldn't route traffic to a secondary vault instance, but it
  # should consider the instance healthy for autohealing purposes.
  # See: https://www.vaultproject.io/api-docs/system/health
  hc_workload_request_path = "/v1/sys/health?uninitcode=200"
  hc_autoheal_request_path = "/v1/sys/health?uninitcode=200&standbyok=true"
  # Default to all zones in the region unless zones were provided.
  zones = length(var.zones) > 0 ? var.zones : data.google_compute_zones.available.names
}

data "google_compute_zones" "available" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_instance_template" "vault" {
  project     = var.project_id
  region      = var.region
  name_prefix = "vault-"

  machine_type = var.vault_machine_type

  tags = concat(["allow-ssh", "allow-vault"], var.vault_instance_tags)

  labels = var.vault_instance_labels

  network_interface {
    subnetwork         = var.subnet
    subnetwork_project = local.host_project
  }

  disk {
    source_image = var.vault_instance_base_image
    type         = "PERSISTENT"
    disk_type    = "pd-ssd"
    mode         = "READ_WRITE"
    boot         = true
  }

  service_account {
    email  = var.vault_service_account_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  metadata = merge(
    var.vault_instance_metadata,
    {
      "google-compute-enable-virtio-rng" = "true"
      # Render the startup script. This script installs and configures
      # Vault and all dependencies.
      "startup-script" = templatefile("${path.module}/templates/startup.sh.tpl",
        {
          custom_http_proxy       = var.http_proxy
          service_account_email   = var.vault_service_account_email
          internal_lb             = local.use_internal_lb
          vault_args              = var.vault_args
          vault_port              = var.vault_port
          vault_proxy_port        = var.vault_proxy_port
          vault_version           = var.vault_version
          vault_tls_bucket        = local.vault_tls_bucket
          vault_ca_cert_filename  = var.vault_ca_cert_filename
          vault_tls_key_filename  = var.vault_tls_key_filename
          vault_tls_cert_filename = var.vault_tls_cert_filename
          kms_project             = var.vault_tls_kms_key_project == "" ? var.project_id : var.vault_tls_kms_key_project
          kms_crypto_key          = local.vault_tls_kms_key
          user_startup_script     = var.user_startup_script
          # Render the Vault configuration.
          config = templatefile("${path.module}/templates/config.hcl.tpl",
            {
              kms_project                              = var.project_id
              kms_location                             = google_kms_key_ring.vault.location
              kms_keyring                              = google_kms_key_ring.vault.name
              kms_crypto_key                           = google_kms_crypto_key.vault-init.name
              lb_ip                                    = local.lb_ip
              api_addr                                 = local.api_addr
              storage_bucket                           = var.vault_storage_bucket
              vault_log_level                          = var.vault_log_level
              vault_port                               = var.vault_port
              vault_proxy_port                         = var.vault_proxy_port
              vault_tls_disable_client_certs           = var.vault_tls_disable_client_certs
              vault_tls_require_and_verify_client_cert = var.vault_tls_require_and_verify_client_cert
              vault_ui_enabled                         = var.vault_ui_enabled
              user_vault_config                        = var.user_vault_config
          })
      })
    },
  )

  lifecycle {
    create_before_destroy = true
  }

}

############################
## Internal Load Balancer ##
############################

resource "google_compute_health_check" "vault_internal" {
  count   = local.use_internal_lb ? 1 : 0
  project = var.project_id
  name    = "vault-health-internal"

  check_interval_sec  = 15
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2

  https_health_check {
    port         = var.vault_port
    request_path = local.hc_workload_request_path
  }
}

resource "google_compute_region_backend_service" "vault_internal" {
  count         = local.use_internal_lb ? 1 : 0
  project       = var.project_id
  name          = "vault-backend-service"
  region        = var.region
  health_checks = [google_compute_health_check.vault_internal[0].self_link]

  backend {
    group = google_compute_region_instance_group_manager.vault.instance_group
  }
}

# Forward internal traffic to the backend service
resource "google_compute_forwarding_rule" "vault_internal" {
  count = local.use_internal_lb ? 1 : 0

  project               = var.project_id
  name                  = "vault-internal"
  region                = var.region
  ip_protocol           = "TCP"
  ip_address            = var.ip_address
  load_balancing_scheme = local.lb_scheme
  network_tier          = "PREMIUM"
  allow_global_access   = true
  subnetwork            = var.subnet
  service_label         = var.service_label

  backend_service = google_compute_region_backend_service.vault_internal[0].self_link
  ports           = [var.vault_port]
}

############################
## External Load Balancer ##
############################

# This legacy health check is required because the target pool requires an HTTP
# health check.
resource "google_compute_http_health_check" "vault" {
  count   = local.use_external_lb ? 1 : 0
  project = var.project_id
  name    = "vault-health-legacy"

  check_interval_sec  = 15
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2
  port                = var.vault_proxy_port
  request_path        = local.hc_workload_request_path
}


resource "google_compute_target_pool" "vault" {
  count   = local.use_external_lb ? 1 : 0
  project = var.project_id

  name   = "vault-tp"
  region = var.region

  health_checks = [google_compute_http_health_check.vault[0].name]
}

# Forward external traffic to the target pool
resource "google_compute_forwarding_rule" "external" {
  count   = local.use_external_lb ? 1 : 0
  project = var.project_id

  name                  = "vault-external"
  region                = var.region
  ip_address            = var.ip_address
  ip_protocol           = "TCP"
  load_balancing_scheme = local.lb_scheme
  network_tier          = "PREMIUM"

  target     = google_compute_target_pool.vault[0].self_link
  port_range = var.vault_port
}



# Vault instance group manager
resource "google_compute_region_instance_group_manager" "vault" {
  provider = google-beta
  project  = var.project_id

  name   = "vault-igm"
  region = var.region

  base_instance_name = "vault-${var.region}"
  wait_for_instances = false

  auto_healing_policies {
    health_check      = google_compute_health_check.autoheal.id
    initial_delay_sec = var.hc_initial_delay_secs
  }

  update_policy {
    type                  = var.vault_update_policy_type
    minimal_action        = "REPLACE"
    max_unavailable_fixed = length(local.zones)
    min_ready_sec         = var.min_ready_sec
  }

  target_pools = local.use_external_lb ? [google_compute_target_pool.vault[0].self_link] : []

  named_port {
    name = "vault-http"
    port = var.vault_port
  }

  version {
    instance_template = google_compute_instance_template.vault.self_link
  }
}

# Autoscaling policies for vault
resource "google_compute_region_autoscaler" "vault" {
  project = var.project_id

  name   = "vault-as"
  region = var.region
  target = google_compute_region_instance_group_manager.vault.self_link

  autoscaling_policy {
    min_replicas    = var.vault_min_num_servers
    max_replicas    = var.vault_max_num_servers
    cooldown_period = 300

    cpu_utilization {
      target = 0.8
    }
  }

}

# Auto-healing
resource "google_compute_health_check" "autoheal" {
  project = var.project_id
  name    = "vault-health-autoheal"

  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 1
  unhealthy_threshold = 2

  https_health_check {
    port         = var.vault_port
    request_path = local.hc_autoheal_request_path
  }
}



# Create the KMS key ring
resource "google_kms_key_ring" "vault" {
  name     = var.kms_keyring
  location = var.region
  project  = var.project_id
}

# Create the crypto key for encrypting init keys
resource "google_kms_crypto_key" "vault-init" {
  name            = var.kms_crypto_key
  key_ring        = google_kms_key_ring.vault.id
  rotation_period = "604800s"

  version_template {
    algorithm        = "GOOGLE_SYMMETRIC_ENCRYPTION"
    protection_level = upper(var.kms_protection_level)
  }
}

#
# TLS self-signed certs for Vault.
#
locals {
  manage_tls_count          = var.manage_tls ? 1 : 0
  tls_save_ca_to_disk_count = var.tls_save_ca_to_disk ? 1 : 0
}

# Generate a self-sign TLS certificate that will act as the root CA.
resource "tls_private_key" "root" {
  count = local.manage_tls_count

  algorithm = "RSA"
  rsa_bits  = "2048"
}

# Sign ourselves
resource "tls_self_signed_cert" "root" {
  count = local.manage_tls_count

  private_key_pem = tls_private_key.root[0].private_key_pem

  subject {
    common_name         = var.tls_ca_subject.common_name
    country             = var.tls_ca_subject.country
    locality            = var.tls_ca_subject.locality
    organization        = var.tls_ca_subject.organization
    organizational_unit = var.tls_ca_subject.organizational_unit
    postal_code         = var.tls_ca_subject.postal_code
    province            = var.tls_ca_subject.province
    street_address      = var.tls_ca_subject.street_address
  }

  validity_period_hours = 26280
  early_renewal_hours   = 8760
  is_ca_certificate     = true

  allowed_uses = ["cert_signing"]
}

# Save the root CA locally for TLS verification
resource "local_file" "root" {
  count = min(local.manage_tls_count, local.tls_save_ca_to_disk_count)

  filename = var.tls_save_ca_to_disk_filename
  content  = tls_self_signed_cert.root[0].cert_pem
}

# Vault server key
resource "tls_private_key" "vault-server" {
  count = local.manage_tls_count

  algorithm = "RSA"
  rsa_bits  = "2048"
}

# Create the request to sign the cert with our CA
resource "tls_cert_request" "vault-server" {
  count = local.manage_tls_count

  private_key_pem = tls_private_key.vault-server[0].private_key_pem

  dns_names = var.tls_dns_names

  ip_addresses = concat([local.lb_ip], var.tls_ips)

  subject {
    common_name         = var.tls_cn
    organization        = var.tls_ca_subject["organization"]
    organizational_unit = var.tls_ou
  }
}

# Sign the cert
resource "tls_locally_signed_cert" "vault-server" {
  count = local.manage_tls_count

  cert_request_pem   = tls_cert_request.vault-server[0].cert_request_pem
  ca_private_key_pem = tls_private_key.root[0].private_key_pem
  ca_cert_pem        = tls_self_signed_cert.root[0].cert_pem

  validity_period_hours = 17520
  early_renewal_hours   = 8760

  allowed_uses = ["server_auth"]
}

# Encrypt server key with GCP KMS
resource "google_kms_secret_ciphertext" "vault-tls-key-encrypted" {
  count = local.manage_tls_count

  crypto_key = google_kms_crypto_key.vault-init.id
  plaintext  = tls_private_key.vault-server[0].private_key_pem
}

resource "google_storage_bucket_object" "vault-private-key" {
  count = local.manage_tls_count

  name    = var.vault_tls_key_filename
  content = google_kms_secret_ciphertext.vault-tls-key-encrypted[0].ciphertext
  bucket  = local.vault_tls_bucket

  # Ciphertext changes on each invocation, so ignore changes
  lifecycle {
    ignore_changes = [
      content,
    ]
  }
}

resource "google_storage_bucket_object" "vault-server-cert" {
  count = local.manage_tls_count

  name    = var.vault_tls_cert_filename
  content = tls_locally_signed_cert.vault-server[0].cert_pem
  bucket  = local.vault_tls_bucket
}

resource "google_storage_bucket_object" "vault-ca-cert" {
  count = local.manage_tls_count

  name    = var.vault_ca_cert_filename
  content = tls_self_signed_cert.root[0].cert_pem
  bucket  = local.vault_tls_bucket
}



locals {
  service_account_member = "serviceAccount:${var.vault_service_account_email}"
}

# Give project-level IAM permissions to the service account.
resource "google_project_iam_member" "project-iam" {
  for_each = toset(var.service_account_project_iam_roles)
  project  = var.project_id
  role     = each.value
  member   = local.service_account_member
}

# Give additional project-level IAM permissions to the service account.
resource "google_project_iam_member" "additional-project-iam" {
  for_each = toset(var.service_account_project_additional_iam_roles)
  project  = var.project_id
  role     = each.key
  member   = local.service_account_member
}

# Give bucket-level permissions to the service account.
resource "google_storage_bucket_iam_member" "vault" {
  for_each = toset(var.service_account_storage_bucket_iam_roles)
  bucket   = var.vault_storage_bucket
  role     = each.key
  member   = local.service_account_member
}

# Give kms cryptokey-level permissions to the service account.
resource "google_kms_crypto_key_iam_member" "ck-iam" {
  crypto_key_id = google_kms_crypto_key.vault-init.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = local.service_account_member
}

resource "google_kms_crypto_key_iam_member" "tls-ck-iam" {
  count = var.manage_tls == false ? 1 : 0

  crypto_key_id = var.vault_tls_kms_key
  role          = "roles/cloudkms.cryptoKeyDecrypter"
  member        = local.service_account_member
}

resource "google_storage_bucket_iam_member" "tls-bucket-iam" {
  count = var.manage_tls == false ? 1 : 0

  bucket = var.vault_tls_bucket
  role   = "roles/storage.objectViewer"
  member = local.service_account_member
}
