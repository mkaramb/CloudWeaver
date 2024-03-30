
provider "google" {
  project = var.project
}

provider "google-beta" {
  project = var.project
}

resource "google_compute_network" "default" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name                     = var.network_name
  ip_cidr_range            = "10.127.0.0/20"
  network                  = google_compute_network.default.self_link
  region                   = var.region
  private_ip_google_access = true
}

resource "google_compute_router" "default" {
  name    = "lb-https-redirect-router"
  network = google_compute_network.default.self_link
  region  = var.region
}

module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 5.0"
  router     = google_compute_router.default.name
  project_id = var.project
  region     = var.region
  name       = "cloud-nat-lb-https-redirect"
}

data "template_file" "group-startup-script" {
  template = file(format("%s/gceme.sh.tpl", path.module))

  vars = {
    PROXY_PATH = ""
  }
}

module "mig_template" {
  source     = "terraform-google-modules/vm/google//modules/instance_template"
  version    = "~> 7.9"
  network    = google_compute_network.default.self_link
  subnetwork = google_compute_subnetwork.default.self_link
  service_account = {
    email  = ""
    scopes = ["cloud-platform"]
  }
  name_prefix    = var.network_name
  startup_script = data.template_file.group-startup-script.rendered
  tags = [
    var.network_name,
    module.cloud-nat.router_name
  ]
}

module "mig" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "~> 7.9"
  instance_template = module.mig_template.self_link
  region            = var.region
  hostname          = var.network_name
  target_size       = 2
  named_ports = [{
    name = "http",
    port = 80
  }]
  network    = google_compute_network.default.self_link
  subnetwork = google_compute_subnetwork.default.self_link
}

# [START cloudloadbalancing_ext_http_gce_http_redirect]
module "gce-lb-http" {
  source            = "terraform-google-modules/lb-http/google"
  version           = "~> 10.0"
  name              = "ci-https-redirect"
  project           = var.project
  target_tags       = [var.network_name]
  firewall_networks = [google_compute_network.default.name]
  ssl               = true
  ssl_certificates  = [google_compute_ssl_certificate.example.self_link]
  https_redirect    = true

  backends = {
    default = {
      protocol    = "HTTP"
      port        = 80
      port_name   = "http"
      timeout_sec = 10
      enable_cdn  = false

      health_check = {
        request_path = "/"
        port         = 80
      }

      log_config = {
        enable = false
      }

      groups = [
        {
          group = module.mig.instance_group
        }
      ]
      iap_config = {
        enable = false
      }
    }
  }
}
# [END cloudloadbalancing_ext_http_gce_http_redirect]



resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "example" {
  private_key_pem = tls_private_key.example.private_key_pem

  # Certificate expires after 12 hours.
  validity_period_hours = 12

  # Generate a new certificate if Terraform is run within three
  # hours of the certificate's expiration time.
  early_renewal_hours = 3

  # Reasonable set of uses for a server SSL certificate.
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  dns_names = ["example.com"]

  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }
}

resource "google_compute_ssl_certificate" "example" {
  name        = "${var.network_name}-cert"
  private_key = tls_private_key.example.private_key_pem
  certificate = tls_self_signed_cert.example.cert_pem
}
