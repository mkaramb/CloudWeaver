
provider "google" {
  credentials = file(var.credentials_path)
}

module "onprem_network" {
  source                   = "./onprem_project"
  project_id               = var.onprem_project_id
  organization_id          = var.organization_id
  billing_account_id       = var.billing_account_id
  region                   = var.region
  vpn_shared_secret        = var.vpn_shared_secret
  ip_addr_cloud_vpn_router = module.vpc_sc_network.ip_addr_cloud_vpn_router
}

module "vpc_sc_network" {
  source                    = "./vpc_sc_project"
  project_id                = var.vpc_sc_project_id
  organization_id           = var.organization_id
  billing_account_id        = var.billing_account_id
  region                    = var.region
  vpn_shared_secret         = var.vpn_shared_secret
  ip_addr_onprem_vpn_router = module.onprem_network.ip_addr_onprem_vpn_router
  access_policy_name        = var.access_policy_name
}
