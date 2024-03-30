
output "ip_addr_cloud_vpn_router" {
  value       = google_compute_address.vpc_sc_vpn_ip.address
  description = "IP address of the VPN router in the VPC Service Control project"
}

output "windows_cloud_private_ip" {
  value       = google_compute_instance.vpc_sc_windows_instance.network_interface[0].network_ip
  description = "Private IP address for the 'cloud-based' Windows instance"
}
