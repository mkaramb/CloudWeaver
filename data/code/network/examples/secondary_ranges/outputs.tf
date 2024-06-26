
output "network_name" {
  value       = module.vpc-secondary-ranges.network_name
  description = "The name of the VPC being created"
}

output "network_self_link" {
  value       = module.vpc-secondary-ranges.network_self_link
  description = "The URI of the VPC being created"
}

output "project_id" {
  value       = module.vpc-secondary-ranges.project_id
  description = "VPC project id"
}

output "subnets_names" {
  value       = module.vpc-secondary-ranges.subnets_names
  description = "The names of the subnets being created"
}

output "subnets_ips" {
  value       = module.vpc-secondary-ranges.subnets_ips
  description = "The IP and cidrs of the subnets being created"
}

output "subnets_regions" {
  value       = module.vpc-secondary-ranges.subnets_regions
  description = "The region where subnets will be created"
}

output "subnets_private_access" {
  value       = module.vpc-secondary-ranges.subnets_private_access
  description = "Whether the subnets will have access to Google API's without a public IP"
}

output "subnets_flow_logs" {
  value       = module.vpc-secondary-ranges.subnets_flow_logs
  description = "Whether the subnets will have VPC flow logs enabled"
}

output "subnets_secondary_ranges" {
  value       = flatten(module.vpc-secondary-ranges.subnets_secondary_ranges)
  description = "The secondary ranges associated with these subnets"
}

output "route_names" {
  value       = module.vpc-secondary-ranges.route_names
  description = "The routes associated with this VPC"
}
