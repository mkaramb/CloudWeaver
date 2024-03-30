
##To MGMT VPC
module "vpn-ha-to-mgmt" {
  source  = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version = "~> 4.0"

  project_id       = var.prod_project_id
  region           = var.region
  network          = var.prod_network_self_link
  name             = "prod-to-mgmt"
  router_asn       = 64513
  peer_gcp_gateway = module.vpn-ha-to-prod.self_link
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.2"
        asn     = 64514
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.1.1/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = null
      shared_secret                   = module.vpn-ha-to-prod.random_secret
    }
    remote-1 = {
      bgp_peer = {
        address = "169.254.2.2"
        asn     = 64514
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.2.1/30"
      ike_version                     = 2
      vpn_gateway_interface           = 1
      peer_external_gateway_interface = null
      shared_secret                   = module.vpn-ha-to-prod.random_secret
    }
  }
}
