
module "vpn-gw-us-we1-prd-mgt-internal" {
  source  = "terraform-google-modules/vpn/google"
  version = "~> 4.0"

  project_id         = var.prod_project_id
  network            = var.prod_network
  region             = "us-west1"
  gateway_name       = "vpn-gw-us-we1-prd-mgt-internal"
  tunnel_name_prefix = "vpn-tn-us-we1-prd-mgt-internal"
  shared_secret      = "secrets"
  tunnel_count       = 1
  peer_ips           = [module.vpn-gw-us-we1-mgt-prd-internal.gateway_ip]

  route_priority = 1000
  remote_subnet  = ["10.17.32.0/20", "10.17.16.0/20"]
}

