
output "mgt_project_id" {
  value = var.mgt_project_id
}

output "mgt_gateway_name" {
  description = "Mgt VPN gateway name."
  value       = module.vpn-ha-to-prod.name
}

output "mgt_tunnel_names" {
  description = "Mgt VPN tunnel names."
  value       = module.vpn-ha-to-prod.tunnel_names
}

output "mgt_tunnel_names_list" {
  description = "Mgt VPN tunnel names list."
  value       = [for x, y in module.vpn-ha-to-prod.tunnel_names : y]
}

output "prod_project_id" {
  value = var.prod_project_id
}

output "prod_gateway_name" {
  description = "Prod VPN gateway name."
  value       = module.vpn-ha-to-mgmt.name
}

output "prod_tunnel_names" {
  description = "Prod VPN tunnel names."
  value       = module.vpn-ha-to-mgmt.tunnel_names
}

output "prod_tunnel_names_list" {
  description = "Prod VPN tunnel names list."
  value       = [for x, y in module.vpn-ha-to-mgmt.tunnel_names : y]
}

output "region" {
  description = "Region"
  value       = var.region
}
