
locals {
  cluster_type = "simple-zonal-private"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

data "google_compute_subnetwork" "subnetwork" {
  name    = var.subnetwork
  project = var.project_id
  region  = var.region
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version = "~> 30.0"

  project_id              = var.project_id
  name                    = "${local.cluster_type}-cluster${var.cluster_name_suffix}"
  regional                = false
  region                  = var.region
  zones                   = var.zones
  network                 = var.network
  subnetwork              = var.subnetwork
  ip_range_pods           = var.ip_range_pods
  ip_range_services       = var.ip_range_services
  create_service_account  = false
  service_account         = var.compute_engine_service_account
  enable_private_endpoint = true
  enable_private_nodes    = true
  master_ipv4_cidr_block  = "172.16.0.0/28"
  deletion_protection     = false

  master_authorized_networks = [
    {
      cidr_block   = data.google_compute_subnetwork.subnetwork.ip_cidr_range
      display_name = "VPC"
    },
  ]
}
