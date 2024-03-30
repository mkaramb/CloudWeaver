
resource "google_compute_router" "router" {
  name        = var.name
  network     = var.network
  region      = var.region
  project     = var.project
  description = var.description

  dynamic "bgp" {
    for_each = var.bgp != null ? [var.bgp] : []
    content {
      asn = var.bgp.asn

      # advertise_mode is intentionally set to CUSTOM to not allow "DEFAULT".
      # This forces the config to explicitly state what subnets and ip ranges
      # to advertise. To advertise the same range as DEFAULT, set
      # `advertise_groups = ["ALL_SUBNETS"]`.
      advertise_mode     = "CUSTOM"
      advertised_groups  = lookup(var.bgp, "advertised_groups", null)
      keepalive_interval = lookup(var.bgp, "keepalive_interval", null)

      dynamic "advertised_ip_ranges" {
        for_each = lookup(var.bgp, "advertised_ip_ranges", [])
        content {
          range       = advertised_ip_ranges.value.range
          description = lookup(advertised_ip_ranges.value, "description", null)
        }
      }
    }
  }

}



resource "google_compute_router_nat" "nats" {
  for_each = {
    for n in var.nats :
    n.name => n
  }

  name                                = each.value.name
  project                             = google_compute_router.router.project
  router                              = google_compute_router.router.name
  region                              = google_compute_router.router.region
  nat_ip_allocate_option              = coalesce(each.value.nat_ip_allocate_option, length(each.value.nat_ips) > 0 ? "MANUAL_ONLY" : "AUTO_ONLY")
  source_subnetwork_ip_ranges_to_nat  = coalesce(each.value.source_subnetwork_ip_ranges_to_nat, "ALL_SUBNETWORKS_ALL_IP_RANGES")
  nat_ips                             = each.value.nat_ips
  min_ports_per_vm                    = each.value.min_ports_per_vm
  max_ports_per_vm                    = each.value.max_ports_per_vm
  udp_idle_timeout_sec                = each.value.udp_idle_timeout_sec
  icmp_idle_timeout_sec               = each.value.icmp_idle_timeout_sec
  tcp_established_idle_timeout_sec    = each.value.tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec     = each.value.tcp_transitory_idle_timeout_sec
  tcp_time_wait_timeout_sec           = each.value.tcp_time_wait_timeout_sec
  enable_endpoint_independent_mapping = each.value.enable_endpoint_independent_mapping
  enable_dynamic_port_allocation      = each.value.enable_dynamic_port_allocation

  log_config {
    enable = each.value.log_config.enable
    filter = each.value.log_config.filter
  }

  dynamic "subnetwork" {
    for_each = each.value.subnetworks
    content {
      name                     = subnetwork.value.name
      source_ip_ranges_to_nat  = subnetwork.value.source_ip_ranges_to_nat
      secondary_ip_range_names = subnetwork.value.secondary_ip_range_names
    }
  }
}
