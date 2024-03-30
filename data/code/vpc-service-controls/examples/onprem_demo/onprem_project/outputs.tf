
output "ip_addr_onprem_vpn_router" {
  value       = google_compute_address.onprem_vpn_ip.address
  description = "IP address of the VPN router in the onprem network project"
}

output "windows_onprem_public_ip" {
  value       = google_compute_instance.windows_jumphost.network_interface[0].access_config[0].nat_ip
  description = "Public IP address for the 'onprem' Windows jumphost"
}
