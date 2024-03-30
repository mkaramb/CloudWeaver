
provider "google" {
  project = var.project_id
}

provider "google-beta" {
  project = var.project_id
}

resource "google_compute_network" "default" {
  name                    = var.network_name
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "group1" {
  name                     = var.network_name
  ip_cidr_range            = "10.125.0.0/20"
  network                  = google_compute_network.default.self_link
  region                   = var.group1_region
  private_ip_google_access = true
}

# Router and Cloud NAT are required for installing packages from repos (apache, php etc)
resource "google_compute_router" "group1" {
  name    = "${var.network_name}-gw-group1"
  network = google_compute_network.default.self_link
  region  = var.group1_region
}

module "cloud-nat-group1" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 5.0"
  router     = google_compute_router.group1.name
  project_id = var.project_id
  region     = var.group1_region
  name       = "${var.network_name}-cloud-nat-group1"
}

resource "random_id" "assets-bucket" {
  prefix      = "terraform-static-content-"
  byte_length = 2
}

locals {
  health_check = {
    request_path = "/"
    port         = 80
  }
}

module "gce-lb-https" {
  source  = "terraform-google-modules/lb-http/google"
  version = "~> 10.0"

  name                            = var.network_name
  project                         = var.project_id
  firewall_networks               = [google_compute_network.default.self_link]
  url_map                         = google_compute_url_map.https-multi-cert.self_link
  create_url_map                  = false
  ssl                             = true
  create_ssl_certificate          = true
  private_key                     = tls_private_key.single_key.private_key_pem
  certificate                     = tls_self_signed_cert.single_cert.cert_pem
  managed_ssl_certificate_domains = ["test.example.com"]
  ssl_certificates                = google_compute_ssl_certificate.example.*.self_link

  backends = {
    default = {
      protocol    = "HTTP"
      port        = 80
      port_name   = "http"
      timeout_sec = 10
      enable_cdn  = false

      health_check = local.health_check
      log_config = {
        enable      = true
        sample_rate = 1.0
      }
      groups = [
        {
          group = module.mig1.instance_group
        },
      ]

      iap_config = {
        enable = false
      }
    }

    mig1 = {
      protocol    = "HTTP"
      port        = 80
      port_name   = "http"
      timeout_sec = 10
      enable_cdn  = false

      health_check = local.health_check
      log_config = {
        enable      = true
        sample_rate = 1.0
      }
      groups = [
        {
          group = module.mig1.instance_group
        },
      ]

      iap_config = {
        enable = false
      }
    }
  }

  # depends_on = [google_certificate_manager_certificate_map.certificate_map]
}

resource "google_compute_url_map" "https-multi-cert" {
  // note that this is the name of the load balancer
  name            = var.network_name
  default_service = module.gce-lb-https.backend_services["default"].self_link

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = module.gce-lb-https.backend_services["default"].self_link

    path_rule {
      paths = [
        "/group1",
        "/group1/*"
      ]
      service = module.gce-lb-https.backend_services["mig1"].self_link
    }

    path_rule {
      paths = [
        "/assets",
        "/assets/*"
      ]
      service = google_compute_backend_bucket.assets.self_link
    }
  }
}

resource "google_compute_backend_bucket" "assets" {
  name        = random_id.assets-bucket.hex
  description = "Contains static resources for example app"
  bucket_name = google_storage_bucket.assets.name
  enable_cdn  = true
}

resource "google_storage_bucket" "assets" {
  name     = random_id.assets-bucket.hex
  location = "US"

  // delete bucket and contents on destroy.
  force_destroy = true
}

// The image object in Cloud Storage.
// Note that the path in the bucket matches the paths in the url map path rule above.
resource "google_storage_bucket_object" "image" {
  name         = "assets/gcp-logo.svg"
  content      = file("gcp-logo.svg")
  content_type = "image/svg+xml"
  bucket       = google_storage_bucket.assets.name
}

// Make object public readable.
resource "google_storage_object_acl" "image-acl" {
  bucket         = google_storage_bucket.assets.name
  object         = google_storage_bucket_object.image.name
  predefined_acl = "publicRead"
}



resource "tls_private_key" "example" {
  count     = 3
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "example" {
  count           = 3
  private_key_pem = tls_private_key.example[count.index].private_key_pem

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

  dns_names = ["example-${count.index + 1}.com"]

  subject {
    common_name  = "example-${count.index + 1}.com"
    organization = "ACME Examples, Inc"
  }
}

resource "google_compute_ssl_certificate" "example" {
  count       = 3
  name        = "${var.network_name}-cert-${count.index + 1}"
  private_key = tls_private_key.example[count.index].private_key_pem
  certificate = tls_self_signed_cert.example[count.index].cert_pem
}

resource "tls_private_key" "single_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "single_cert" {
  private_key_pem = tls_private_key.single_key.private_key_pem

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

  dns_names = ["example-single.com"]

  subject {
    common_name  = "example-single.com"
    organization = "ACME Examples, Inc"
  }
}



data "template_file" "group1-startup-script" {
  template = file(format("%s/gceme.sh.tpl", path.module))

  vars = {
    PROXY_PATH = "/group1"
  }
}

module "mig1_template" {
  source     = "terraform-google-modules/vm/google//modules/instance_template"
  version    = "~> 7.9"
  network    = google_compute_network.default.self_link
  subnetwork = google_compute_subnetwork.group1.self_link
  service_account = {
    email  = ""
    scopes = ["cloud-platform"]
  }
  name_prefix          = "${var.network_name}-group1"
  startup_script       = data.template_file.group1-startup-script.rendered
  source_image_family  = "ubuntu-2004-lts"
  source_image_project = "ubuntu-os-cloud"
  tags = [
    "${var.network_name}-group1",
    module.cloud-nat-group1.router_name
  ]
}

module "mig1" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "7.9.0"
  instance_template = module.mig1_template.self_link
  region            = var.group1_region
  hostname          = "${var.network_name}-group1"
  target_size       = 2
  named_ports = [{
    name = "http",
    port = 80
  }]
  network    = google_compute_network.default.self_link
  subnetwork = google_compute_subnetwork.group1.self_link
}
