

resource "random_string" "suffix" {
  length  = 8
  upper   = false
  lower   = true
  numeric = true
  special = false
}

locals {
  random_suffix = random_string.suffix.result
  resource_name = "ilb-minimal-${local.random_suffix}"
  health_check = {
    type                = "http"
    check_interval_sec  = 1
    healthy_threshold   = 4
    timeout_sec         = 1
    unhealthy_threshold = 5
    response            = ""
    proxy_header        = "NONE"
    port                = 8081
    port_name           = "health-check-port"
    request             = ""
    request_path        = "/"
    host                = "1.2.3.4"
    enable_log          = false
  }
}

resource "google_compute_network" "test" {
  project                 = var.project_id
  name                    = local.resource_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "test" {
  project       = var.project_id
  name          = local.resource_name
  network       = google_compute_network.test.name
  region        = var.region
  ip_cidr_range = "10.2.0.0/16"
}

# [START cloudloadbalancing_int_tcp_udp_minimal]
module "test_ilb" {
  source  = "GoogleCloudPlatform/lb-internal/google"
  version = "~> 5.0"

  project      = var.project_id
  network      = google_compute_network.test.name
  subnetwork   = google_compute_subnetwork.test.name
  region       = var.region
  name         = local.resource_name
  ports        = ["8080"]
  source_tags  = ["source-tag-foo"]
  target_tags  = ["target-tag-bar"]
  backends     = []
  health_check = local.health_check
}
# [END cloudloadbalancing_int_tcp_udp_minimal]
