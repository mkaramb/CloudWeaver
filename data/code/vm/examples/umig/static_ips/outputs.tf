
output "self_links" {
  description = "List of self-links of unmanaged instance groups"
  value       = module.umig.self_links
}

output "instances_self_links" {
  description = "List of self-links for compute instances"
  value       = module.umig.instances_self_links
}

output "available_zones" {
  description = "List of available zones in region"
  value       = module.umig.available_zones
}

