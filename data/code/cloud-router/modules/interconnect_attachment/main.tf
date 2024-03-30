
resource "google_compute_interconnect_attachment" "attachment" {
  name              = var.name
  router            = var.router
  project           = var.project
  region            = var.region
  interconnect      = var.interconnect
  admin_enabled     = var.admin_enabled
  type              = var.type
  description       = var.description
  bandwidth         = var.bandwidth
  mtu               = var.mtu
  candidate_subnets = var.candidate_subnets
  vlan_tag8021q     = var.vlan_tag8021q
}

module "interface" {
  source                  = "../interface"
  name                    = var.interface.name
  project                 = var.project
  router                  = var.router
  region                  = var.region
  ip_range                = google_compute_interconnect_attachment.attachment.cloud_router_ip_address
  interconnect_attachment = google_compute_interconnect_attachment.attachment.self_link
  peers = [{
    name = var.peer.name

    # Peer IP Address must not contain the subnet mask, else will throw an invalid IP address error.
    peer_ip_address           = element(split("/", google_compute_interconnect_attachment.attachment.customer_router_ip_address), 0)
    peer_asn                  = var.peer.peer_asn
    advertised_route_priority = lookup(var.peer, "advertised_route_priority", null)
    bfd                       = lookup(var.peer, "bfd", null)
  }]
}
