
module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/safer-cluster"
  version = "~> 30.0"

  project_id              = module.enabled_google_apis.project_id
  name                    = var.cluster_name
  region                  = var.region
  network                 = module.vpc.network_name
  subnetwork              = module.vpc.subnets_names[0]
  ip_range_pods           = module.vpc.subnets_secondary_ranges[0][0].range_name
  ip_range_services       = module.vpc.subnets_secondary_ranges[0][1].range_name
  enable_private_endpoint = false
  deletion_protection     = false
  master_authorized_networks = [{
    cidr_block   = "${module.bastion.ip_address}/32"
    display_name = "Bastion Host"
  }]
  database_encryption = [
    {
      "key_name" : module.kms.keys["gke-key"],
      "state" : "ENCRYPTED"
    }
  ]
  grant_registry_access = true
  node_pools = [
    {
      name          = "safer-pool"
      min_count     = 1
      max_count     = 4
      auto_upgrade  = true
      node_metadata = "GKE_METADATA"
    }
  ]
}
