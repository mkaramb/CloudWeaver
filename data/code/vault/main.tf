
locals {
  lb_scheme       = upper(var.load_balancing_scheme)
  use_internal_lb = local.lb_scheme == "INTERNAL"
  use_external_lb = local.lb_scheme == "EXTERNAL"
  ip_address      = local.use_internal_lb ? google_compute_address.vault_ilb[0].address : google_compute_address.vault[0].address
}

# Enable required services on the project
resource "google_project_service" "service" {
  for_each = toset(var.project_services)
  project  = var.project_id

  service = each.key

  # Do not disable the service on destroy. This may be a shared project, and
  # we might not "own" the services we enable.
  disable_on_destroy = false
}

# Create the vault-admin service account.
resource "google_service_account" "vault-admin" {
  account_id   = var.service_account_name
  display_name = "Vault Admin"
  project      = var.project_id

  depends_on = [google_project_service.service]
}

module "cluster" {
  source                                       = "./modules/cluster"
  ip_address                                   = local.ip_address
  subnet                                       = local.subnet
  service_label                                = var.service_label
  project_id                                   = var.project_id
  host_project_id                              = var.host_project_id
  region                                       = var.region
  vault_storage_bucket                         = google_storage_bucket.vault.name
  vault_service_account_email                  = google_service_account.vault-admin.email
  service_account_project_additional_iam_roles = var.service_account_project_additional_iam_roles
  service_account_storage_bucket_iam_roles     = var.service_account_storage_bucket_iam_roles
  kms_keyring                                  = var.kms_keyring
  kms_crypto_key                               = var.kms_crypto_key
  kms_protection_level                         = var.kms_protection_level
  load_balancing_scheme                        = var.load_balancing_scheme
  vault_args                                   = var.vault_args
  vault_instance_labels                        = var.vault_instance_labels
  vault_ca_cert_filename                       = var.vault_ca_cert_filename
  vault_instance_metadata                      = var.vault_instance_metadata
  vault_instance_base_image                    = var.vault_instance_base_image
  vault_instance_tags                          = var.vault_instance_tags
  vault_log_level                              = var.vault_log_level
  vault_min_num_servers                        = var.vault_min_num_servers
  vault_machine_type                           = var.vault_machine_type
  vault_max_num_servers                        = var.vault_max_num_servers
  vault_update_policy_type                     = var.vault_update_policy_type
  vault_port                                   = var.vault_port
  vault_proxy_port                             = var.vault_proxy_port
  vault_tls_disable_client_certs               = var.vault_tls_disable_client_certs
  vault_tls_require_and_verify_client_cert     = var.vault_tls_require_and_verify_client_cert
  vault_tls_bucket                             = var.vault_tls_bucket
  vault_tls_kms_key                            = var.vault_tls_kms_key
  vault_tls_kms_key_project                    = var.vault_tls_kms_key_project
  vault_tls_cert_filename                      = var.vault_tls_cert_filename
  vault_tls_key_filename                       = var.vault_tls_key_filename
  vault_ui_enabled                             = var.vault_ui_enabled
  vault_version                                = var.vault_version
  http_proxy                                   = var.http_proxy
  user_startup_script                          = var.user_startup_script
  user_vault_config                            = var.user_vault_config
  manage_tls                                   = var.manage_tls
  tls_ca_subject                               = var.tls_ca_subject
  tls_cn                                       = var.tls_cn
  domain                                       = var.domain
  tls_dns_names                                = var.tls_dns_names
  tls_ips                                      = var.tls_ips
  tls_save_ca_to_disk                          = var.tls_save_ca_to_disk
  tls_save_ca_to_disk_filename                 = var.tls_save_ca_to_disk_filename
  tls_ou                                       = var.tls_ou
  service_account_project_iam_roles            = var.service_account_project_iam_roles
}



#
# This file contains the networking bits.
#
locals {
  network            = var.network == "" ? google_compute_network.vault-network[0].self_link : var.network
  subnet             = var.subnet == "" ? google_compute_subnetwork.vault-subnet[0].self_link : var.subnet
  network_project_id = var.host_project_id == "" ? var.project_id : var.host_project_id
}

# Address for NATing
resource "google_compute_address" "vault-nat" {
  count   = var.allow_public_egress ? 2 : 0
  project = local.network_project_id
  name    = "vault-nat-external-${count.index}"
  region  = var.region

  depends_on = [google_project_service.service]
}

resource "google_compute_address" "vault_ilb" {
  count        = local.use_internal_lb ? 1 : 0
  subnetwork   = local.subnet
  name         = "vault-ilb"
  address_type = "INTERNAL"
  project      = var.project_id
  region       = var.region

  depends_on = [google_project_service.service]
}

# Create a NAT router so the nodes can reach the public Internet
resource "google_compute_router" "vault-router" {
  count   = var.allow_public_egress ? 1 : 0
  name    = "vault-router"
  project = local.network_project_id
  region  = var.region
  network = local.network

  bgp {
    asn                = 64514
    keepalive_interval = 20
  }

  depends_on = [google_project_service.service]
}

# NAT on the main subnetwork
resource "google_compute_router_nat" "vault-nat" {
  count   = var.allow_public_egress ? 1 : 0
  name    = "vault-nat-1"
  project = local.network_project_id
  router  = google_compute_router.vault-router[0].name
  region  = var.region

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = google_compute_address.vault-nat.*.self_link

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = local.subnet
    source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE"]
  }

  depends_on = [google_project_service.service]
}

resource "google_compute_network" "vault-network" {
  count   = var.network == "" ? 1 : 0
  project = var.project_id

  name                    = "vault-network"
  auto_create_subnetworks = false

  depends_on = [google_project_service.service]
}

resource "google_compute_subnetwork" "vault-subnet" {
  count   = var.subnet == "" ? 1 : 0
  project = var.project_id

  name                     = "vault-subnet"
  region                   = var.region
  ip_cidr_range            = var.network_subnet_cidr_range
  network                  = local.network
  private_ip_google_access = true

  depends_on = [google_project_service.service]
}

resource "google_compute_address" "vault" {
  count   = local.use_external_lb ? 1 : 0
  project = var.project_id

  name   = "vault-lb"
  region = var.region

  depends_on = [google_project_service.service]
}

# Data source for list of google IPs
data "google_compute_lb_ip_ranges" "ranges" {
  # hashicorp/terraform#20484 prevents us from depending on the service
}

# Allow the load balancers to talk to query the health - this happens over the
# legacy proxied health port over HTTP because the health checks do not support
# HTTPS.
resource "google_compute_firewall" "allow-lb-healthcheck" {
  project = local.network_project_id
  name    = "vault-allow-lb-healthcheck"
  network = local.network

  allow {
    protocol = "tcp"
    ports    = [local.use_internal_lb ? var.vault_port : var.vault_proxy_port]
  }

  source_ranges = concat(data.google_compute_lb_ip_ranges.ranges.network, data.google_compute_lb_ip_ranges.ranges.http_ssl_tcp_internal)

  target_tags = ["allow-vault"]

  depends_on = [google_project_service.service]
}

# Allow any user-defined CIDRs to talk to the Vault instances.
resource "google_compute_firewall" "allow-external" {
  project = local.network_project_id
  name    = "vault-allow-external"
  network = local.network

  allow {
    protocol = "tcp"
    ports    = [var.vault_port]
  }

  source_ranges = var.vault_allowed_cidrs

  target_tags = ["allow-vault"]

  depends_on = [google_project_service.service]
}

# Allow Vault nodes to talk internally on the Vault ports.
resource "google_compute_firewall" "allow-internal" {
  project = local.network_project_id
  name    = "vault-allow-internal"
  network = local.network

  allow {
    protocol = "tcp"
    ports    = ["${var.vault_port}-${var.vault_port + 1}"]
  }

  source_ranges = [var.network_subnet_cidr_range]

  depends_on = [google_project_service.service]
}

# Allow SSHing into machines tagged "allow-ssh"
resource "google_compute_firewall" "allow-ssh" {
  count   = var.allow_ssh ? 1 : 0
  project = local.network_project_id
  name    = "vault-allow-ssh"
  network = local.network

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.ssh_allowed_cidrs
  target_tags   = ["allow-ssh"]

  depends_on = [google_project_service.service]
}




locals {
  # Allow the user to specify a custom bucket name, default to project-id prefix
  storage_bucket_name = var.storage_bucket_name != "" ? var.storage_bucket_name : "${var.project_id}-vault-data"
}

# Create the storage bucket for where Vault data will be stored. This is a
# multi-regional storage bucket so it has the highest level of availability.
resource "google_storage_bucket" "vault" {
  project = var.project_id

  name          = local.storage_bucket_name
  location      = upper(var.storage_bucket_location)
  storage_class = upper(var.storage_bucket_class)

  versioning {
    enabled = var.storage_bucket_enable_versioning
  }

  dynamic "lifecycle_rule" {
    for_each = var.storage_bucket_lifecycle_rules

    content {
      action {
        type          = contains(keys(lifecycle_rule.value.action), "type") ? lifecycle_rule.value.action.type : null
        storage_class = contains(keys(lifecycle_rule.value.action), "storage_class") ? lifecycle_rule.value.action.storage_class : null
      }

      condition {
        age                   = contains(keys(lifecycle_rule.value.condition), "age") ? lifecycle_rule.value.condition.age : null
        created_before        = contains(keys(lifecycle_rule.value.condition), "created_before") ? lifecycle_rule.value.condition.created_before : null
        with_state            = contains(keys(lifecycle_rule.value.condition), "with_state") ? lifecycle_rule.value.condition.with_state : null
        matches_storage_class = contains(keys(lifecycle_rule.value.condition), "matches_storage_class") ? lifecycle_rule.value.condition.matches_storage_class : null
        num_newer_versions    = contains(keys(lifecycle_rule.value.condition), "num_newer_versions") ? lifecycle_rule.value.condition.num_newer_versions : null
      }
    }
  }

  force_destroy = var.storage_bucket_force_destroy

  depends_on = [google_project_service.service]
}
