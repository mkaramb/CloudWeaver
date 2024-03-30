
module "vpn-gw-us-we1-mgt-prd-internal" {
  source  = "terraform-google-modules/vpn/google"
  version = "~> 4.0"

  project_id         = var.mgt_project_id
  network            = var.mgt_network
  region             = "us-west1"
  gateway_name       = "vpn-gw-us-we1-mgt-prd-internal"
  tunnel_name_prefix = "vpn-tn-us-we1-mgt-prd-internal"
  shared_secret      = "secrets"
  tunnel_count       = 1
  peer_ips           = [module.vpn-gw-us-we1-prd-mgt-internal.gateway_ip]

  route_priority = 1000
  remote_subnet  = ["10.17.0.0/22", "10.16.80.0/24"]
}
