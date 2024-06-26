
locals {
  cluster_type = "disable-cluster-cert"
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

  project_id               = var.project_id
  name                     = "${local.cluster_type}-cluster${var.cluster_name_suffix}"
  region                   = var.region
  network                  = var.network
  network_project_id       = var.network_project_id
  subnetwork               = var.subnetwork
  ip_range_pods            = var.ip_range_pods
  ip_range_services        = var.ip_range_services
  create_service_account   = false
  service_account          = var.compute_engine_service_account
  issue_client_certificate = false
  deletion_protection      = false
}
