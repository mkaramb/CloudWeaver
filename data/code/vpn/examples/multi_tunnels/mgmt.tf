
##To Prod VPC
resource "google_compute_router" "cr-uscentral1-to-prod-vpc-01" {
  name    = "cr-uscentral1-to-prod-vpc-tunnels-01"
  region  = "us-central1"
  network = var.mgt_network
  project = var.mgt_project_id

  bgp {
    asn = "64516"
  }
}

resource "google_compute_router" "cr-uscentral1-to-prod-vpc-02" {
  name    = "cr-uscentral1-to-prod-vpc-tunnels-02"
  region  = "us-central1"
  network = var.mgt_network
  project = var.mgt_project_id

  bgp {
    asn = "64521"
  }
}

module "vpn-gw-us-ce1-mgt-prd-internal-01" {
  source  = "terraform-google-modules/vpn/google"
  version = "~> 4.0"

  project_id         = var.mgt_project_id
  network            = var.mgt_network
  region             = "us-central1"
  gateway_name       = "vpn-gw-us-ce1-mgt-prd-internal-01"
  tunnel_name_prefix = "vpn-tn-us-ce1-mgt-prd-internal-01-tunnel"
  shared_secret      = "secrets"
  tunnel_count       = 2
  peer_ips           = [module.vpn-gw-us-ce1-prd-mgt-internal-01.gateway_ip, module.vpn-gw-us-ce1-prd-mgt-internal-02.gateway_ip]

  cr_name                  = "cr-uscentral1-to-prod-vpc-tunnels-01"
  cr_enabled               = true
  bgp_cr_session_range     = ["169.254.0.2/30", "169.254.0.26/30"]
  bgp_remote_session_range = ["169.254.0.1", "169.254.0.25"]
  peer_asn                 = ["64515", "64520"]
}

module "vpn-gw-us-ce1-mgt-prd-internal-02" {
  source  = "terraform-google-modules/vpn/google"
  version = "~> 4.0"

  project_id         = var.mgt_project_id
  network            = var.mgt_network
  region             = "us-central1"
  gateway_name       = "vpn-gw-us-ce1-mgt-prd-internal-02"
  tunnel_name_prefix = "vpn-tn-us-ce1-mgt-prd-internal-02-tunnel"
  shared_secret      = "secrets"
  tunnel_count       = 2
  peer_ips           = [module.vpn-gw-us-ce1-prd-mgt-internal-02.gateway_ip, module.vpn-gw-us-ce1-prd-mgt-internal-01.gateway_ip]

  cr_name                  = "cr-uscentral1-to-prod-vpc-tunnels-02"
  cr_enabled               = true
  bgp_cr_session_range     = ["169.254.0.6/30", "169.254.0.22/30"]
  bgp_remote_session_range = ["169.254.0.5", "169.254.0.21"]
  peer_asn                 = ["64520", "64515"]
}

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

