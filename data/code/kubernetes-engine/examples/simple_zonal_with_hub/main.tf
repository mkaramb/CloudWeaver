
provider "google" {
  region = var.region
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 30.0"

  project_id = var.project_id
  regional   = false
  region     = var.region
  zones      = [var.zone]

  name = "config-sync-cluster${var.cluster_name_suffix}"

  network           = google_compute_network.main.name
  subnetwork        = google_compute_subnetwork.main.name
  ip_range_pods     = google_compute_subnetwork.main.secondary_ip_range[0].range_name
  ip_range_services = google_compute_subnetwork.main.secondary_ip_range[1].range_name

  service_account     = "create"
  deletion_protection = false
  node_pools = [
    {
      name         = "node-pool"
      autoscaling  = false
      auto_upgrade = true
      node_count   = 4
      machine_type = "e2-standard-4"
    },
  ]
}



resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_compute_network" "main" {
  project                 = var.project_id
  name                    = "cft-gke-test-${random_string.suffix.result}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "main" {
  project       = var.project_id
  name          = "cft-gke-test-${random_string.suffix.result}"
  ip_cidr_range = "10.0.0.0/17"
  region        = var.region
  network       = google_compute_network.main.self_link

  secondary_ip_range {
    range_name    = "cft-gke-test-pods-${random_string.suffix.result}"
    ip_cidr_range = "192.168.0.0/18"
  }

  secondary_ip_range {
    range_name    = "cft-gke-test-services-${random_string.suffix.result}"
    ip_cidr_range = "192.168.64.0/18"
  }
}



module "hub" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/fleet-membership"
  version = "~> 30.0"

  project_id   = var.project_id
  location     = module.gke.location
  cluster_name = module.gke.name

  depends_on = [module.gke]
}