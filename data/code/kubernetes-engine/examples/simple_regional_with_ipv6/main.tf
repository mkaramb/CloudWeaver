
locals {
  cluster_type = "simple-regional-ipv6"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source                 = "../../"
  project_id             = var.project_id
  name                   = "${local.cluster_type}-cluster${var.cluster_name_suffix}"
  regional               = true
  region                 = var.region
  network                = var.network
  subnetwork             = var.subnetwork
  ip_range_pods          = var.ip_range_pods
  ip_range_services      = var.ip_range_services
  stack_type             = var.stack_type
  create_service_account = false
  service_account        = var.compute_engine_service_account
  enable_cost_allocation = true
  datapath_provider      = "ADVANCED_DATAPATH"
  deletion_protection    = false
}
