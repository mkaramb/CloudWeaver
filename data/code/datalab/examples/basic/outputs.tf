
output "network_name" {
  description = "Network name"
  value       = module.vpc.network_name
}

output "subnet_name" {
  description = "Subnet name"
  value       = module.vpc.subnets_self_links[0]
}

output "router_name" {
  description = "Google Cloud Router name"
  value       = google_compute_router.main.name
}

output "nat_name" {
  description = "Google Cloud NAT name"
  value       = google_compute_router_nat.main.name
}

output "firewall_name" {
  description = "The name of the firewall rule"
  value       = module.datalab.firewall_name
}

output "disk_name" {
  description = "The name of the persistent disk"
  value       = module.datalab.disk_name
}

output "disk_size" {
  description = "The size of the persistent disk"
  value       = module.datalab.disk_size
}

output "instance_name" {
  description = "The instance name"
  value       = module.datalab.instance_name
}

output "labels" {
  description = "A map of key/value label pairs to assigned to the instance."
  value       = module.datalab.labels
}
