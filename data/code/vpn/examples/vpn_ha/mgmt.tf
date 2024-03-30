
##To Prod VPC
module "vpn-ha-to-prod" {
  source  = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version = "~> 4.0"

  project_id       = var.mgt_project_id
  region           = var.region
  network          = var.mgt_network_self_link
  name             = "mgmt-to-prod"
  peer_gcp_gateway = module.vpn-ha-to-mgmt.self_link
  router_asn       = 64514
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.1"
        asn     = 64513
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.1.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = null
      shared_secret                   = ""
    }
    remote-1 = {
      bgp_peer = {
        address = "169.254.2.1"
        asn     = 64513
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.2.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 1
      peer_external_gateway_interface = null
      shared_secret                   = ""
    }
  }
}
