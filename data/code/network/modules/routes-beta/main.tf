
/******************************************
	Routes
 *****************************************/
resource "google_compute_route" "route" {
  provider = google-beta
  count    = var.routes_count

  project = var.project_id
  network = var.network_name

  name                   = lookup(var.routes[count.index], "name", format("%s-%s-%d", lower(var.network_name), "route", count.index))
  description            = lookup(var.routes[count.index], "description", null)
  tags                   = compact(split(",", lookup(var.routes[count.index], "tags", "")))
  dest_range             = lookup(var.routes[count.index], "destination_range", null)
  next_hop_gateway       = lookup(var.routes[count.index], "next_hop_internet", "false") == "true" ? "default-internet-gateway" : null
  next_hop_ip            = lookup(var.routes[count.index], "next_hop_ip", null)
  next_hop_instance      = lookup(var.routes[count.index], "next_hop_instance", null)
  next_hop_instance_zone = lookup(var.routes[count.index], "next_hop_instance_zone", null)
  next_hop_vpn_tunnel    = lookup(var.routes[count.index], "next_hop_vpn_tunnel", null)
  next_hop_ilb           = lookup(var.routes[count.index], "next_hop_ilb", null)
  priority               = lookup(var.routes[count.index], "priority", null)

  depends_on = [var.module_depends_on]
}
