
module "cloud-nat" {
  source  = "terraform-google-modules/cloud-nat/google"
  version = "~> 5.0"

  project_id                         = var.project_id
  region                             = var.region
  router                             = var.router_name
  name                               = "my-cloud-nat-${var.router_name}"
  nat_ips                            = var.nat_addresses
  min_ports_per_vm                   = "128"
  icmp_idle_timeout_sec              = "15"
  tcp_established_idle_timeout_sec   = "600"
  tcp_transitory_idle_timeout_sec    = "15"
  tcp_time_wait_timeout_sec          = "240"
  udp_idle_timeout_sec               = "15"
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat
  subnetworks                        = var.subnetworks
}
