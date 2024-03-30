
output "network_name" {
  value       = module.vpc.network_name
  description = "The name of the VPC being created"
}

output "network_self_link" {
  value       = module.vpc.network_self_link
  description = "The URI of the VPC being created"
}

output "project_id" {
  value       = module.vpc.project_id
  description = "VPC project id"
}

output "subnets_names" {
  value       = [for network in merge(module.subnets.subnets, module.subnets-backup.subnets) : network.name]
  description = "The names of the subnets being created"
}

output "subnets_ips" {
  value       = [for network in merge(module.subnets.subnets, module.subnets-backup.subnets) : network.ip_cidr_range]
  description = "The IP and cidrs of the subnets being created"
}

output "subnets_regions" {
  value       = [for network in merge(module.subnets.subnets, module.subnets-backup.subnets) : network.region]
  description = "The region where subnets will be created"
}

output "route_names" {
  value       = [for route in module.routes.routes : route.name]
  description = "The routes associated with this VPC"
}

output "forwarding_rule" {
  value       = google_compute_forwarding_rule.this.self_link
  description = "Forwarding rule link"
}
