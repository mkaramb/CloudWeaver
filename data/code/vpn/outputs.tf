
output "project_id" {
  description = "The Project-ID"
  value       = google_compute_vpn_gateway.vpn_gateway.project
}

output "name" {
  description = "The name of the Gateway"
  value       = google_compute_vpn_gateway.vpn_gateway.name
}

output "gateway_self_link" {
  description = "The self-link of the Gateway"
  value       = google_compute_vpn_gateway.vpn_gateway.self_link
}

output "network" {
  description = "The name of the VPC"
  value       = google_compute_vpn_gateway.vpn_gateway.network
}

output "gateway_ip" {
  description = "The VPN Gateway Public IP"
  value       = local.vpn_gw_ip
}

output "vpn_tunnels_names-static" {
  description = "The VPN tunnel name is"
  value       = google_compute_vpn_tunnel.tunnel-static[*].name
}

output "vpn_tunnels_self_link-static" {
  description = "The VPN tunnel self-link is"
  value       = google_compute_vpn_tunnel.tunnel-static[*].self_link
}

output "ipsec_secret-static" {
  description = "The secret"
  value       = google_compute_vpn_tunnel.tunnel-static[*].shared_secret
}

output "vpn_tunnels_names-dynamic" {
  description = "The VPN tunnel name is"
  value       = google_compute_vpn_tunnel.tunnel-dynamic[*].name
}

output "vpn_tunnels_self_link-dynamic" {
  description = "The VPN tunnel self-link is"
  value       = google_compute_vpn_tunnel.tunnel-dynamic[*].self_link
}

output "ipsec_secret-dynamic" {
  description = "The secret"
  value       = google_compute_vpn_tunnel.tunnel-dynamic[*].shared_secret
}
