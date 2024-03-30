
output "project_id" {
  value       = var.project_id
  description = "The project id"
}

output "network_name" {
  value       = module.simple_vpc.network_name
  description = "The network name"
}

output "private_service_connect_name" {
  value       = module.private_service_connect.private_service_connect_name
  description = "Private service connect name"
}

output "private_service_connect_ip" {
  value       = module.private_service_connect.private_service_connect_ip
  description = "The private service connect ip"
}

output "global_address_id" {
  value       = module.private_service_connect.global_address_id
  description = "An identifier for the global address created for the private service connect with format `projects/{{project}}/global/addresses/{{name}}`"
}

output "forwarding_rule_name" {
  value       = module.private_service_connect.forwarding_rule_name
  description = "Forwarding rule resource name."
}

output "forwarding_rule_target" {
  value       = module.private_service_connect.forwarding_rule_target
  description = "Target resource to receive the matched traffic. Only `all-apis` and `vpc-sc` are valid."
}

output "dns_zone_googleapis_name" {
  value       = module.private_service_connect.dns_zone_googleapis_name
  description = "Name for Managed DNS zone for GoogleAPIs"
}

output "dns_zone_gcr_name" {
  value       = module.private_service_connect.dns_zone_gcr_name
  description = "Name for Managed DNS zone for GCR"
}

output "dns_zone_pkg_dev_name" {
  value       = module.private_service_connect.dns_zone_pkg_dev_name
  description = "Name for Managed DNS zone for PKG_DEV"
}
