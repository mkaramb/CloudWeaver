
locals {
  cluster_type = "simple-regional-beta"
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

  project_id                    = var.project_id
  name                          = "${local.cluster_type}-cluster${var.cluster_name_suffix}"
  regional                      = var.regional
  region                        = var.region
  zones                         = var.zones
  network                       = var.network
  subnetwork                    = var.subnetwork
  ip_range_pods                 = var.ip_range_pods
  ip_range_services             = var.ip_range_services
  create_service_account        = var.compute_engine_service_account == "create"
  service_account               = var.compute_engine_service_account
  dns_cache                     = var.dns_cache
  gce_pd_csi_driver             = var.gce_pd_csi_driver
  sandbox_enabled               = var.sandbox_enabled
  remove_default_node_pool      = var.remove_default_node_pool
  node_pools                    = var.node_pools
  database_encryption           = var.database_encryption
  enable_binary_authorization   = var.enable_binary_authorization
  enable_pod_security_policy    = var.enable_pod_security_policy
  enable_identity_service       = true
  release_channel               = "REGULAR"
  logging_enabled_components    = ["SYSTEM_COMPONENTS"]
  monitoring_enabled_components = ["SYSTEM_COMPONENTS"]
  deletion_protection           = false

  # Disable workload identity
  identity_namespace = null
  node_metadata      = "UNSPECIFIED"

  # Enable Dataplane Setup
  datapath_provider = "ADVANCED_DATAPATH"
}
