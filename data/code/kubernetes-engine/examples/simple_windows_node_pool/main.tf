
locals {
  cluster_type = "simple-windows-node-pool"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-public-cluster"
  version = "~> 30.0"

  project_id = var.project_id
  regional   = false
  region     = var.region
  zones      = [var.zone]

  name = "${local.cluster_type}-cluster${var.cluster_name_suffix}"

  network           = google_compute_network.main.name
  subnetwork        = google_compute_subnetwork.main.name
  ip_range_pods     = google_compute_subnetwork.main.secondary_ip_range[0].range_name
  ip_range_services = google_compute_subnetwork.main.secondary_ip_range[1].range_name

  remove_default_node_pool = true
  service_account          = "create"
  release_channel          = "REGULAR"
  deletion_protection      = false

  node_pools = [
    {
      name         = "pool-01"
      autoscaling  = false
      auto_upgrade = true
      node_count   = 1
      machine_type = "n2-standard-2"
    },
  ]

  windows_node_pools = [
    {
      name         = "win-pool-01"
      autoscaling  = false
      auto_upgrade = true
      node_count   = 1
      machine_type = "n2-standard-2"
      image_type   = "WINDOWS_LTSC_CONTAINERD"
    },
  ]
}



resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_compute_network" "main" {
  name                    = "cft-gke-test-${random_string.suffix.result}"
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_compute_subnetwork" "main" {
  name          = "cft-gke-test-${random_string.suffix.result}"
  ip_cidr_range = "10.0.0.0/17"
  region        = var.region
  network       = google_compute_network.main.self_link
  project       = var.project_id

  secondary_ip_range {
    range_name    = "cft-gke-test-pods-${random_string.suffix.result}"
    ip_cidr_range = "192.168.0.0/18"
  }

  secondary_ip_range {
    range_name    = "cft-gke-test-services-${random_string.suffix.result}"
    ip_cidr_range = "192.168.64.0/18"
  }
}
