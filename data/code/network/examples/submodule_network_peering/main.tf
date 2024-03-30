
module "local-network" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.0"

  project_id   = var.project_id
  network_name = "local-network"
  subnets      = []
}

module "peer-network-1" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.0"

  project_id   = var.project_id
  network_name = "peer-network-1"
  subnets      = []
}

module "peer-network-2" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.0"

  project_id   = var.project_id
  network_name = "peer-network-2"
  subnets      = []
}

module "peering-1" {
  source  = "terraform-google-modules/network/google//modules/network-peering"
  version = "~> 9.0"

  local_network              = module.local-network.network_self_link
  peer_network               = module.peer-network-1.network_self_link
  export_local_custom_routes = true
}

module "peering-2" {
  source  = "terraform-google-modules/network/google//modules/network-peering"
  version = "~> 9.0"

  local_network              = module.local-network.network_self_link
  peer_network               = module.peer-network-2.network_self_link
  export_local_custom_routes = true

  module_depends_on = [module.peering-1.complete]
}
