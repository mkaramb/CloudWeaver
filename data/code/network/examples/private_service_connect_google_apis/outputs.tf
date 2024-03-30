

output "project" {
  value       = google_compute_network.network.project
  description = "Google Cloud project ID"
}

output "network" {
  value       = google_compute_network.network.name
  description = "Name of the VPC network"
}

output "subnetwork" {
  value       = google_compute_subnetwork.vpc_subnetwork.name
  description = "Name of the subnetwork"
}

output "subnet_ip_range" {
  value       = google_compute_subnetwork.vpc_subnetwork.ip_cidr_range
  description = "Subnet IP range"
}

output "ip_address_name" {
  value       = google_compute_global_address.default.name
  description = "The name of the internal IP address"
}

output "ip_address" {
  value       = google_compute_global_address.default.address
  description = "The internal IP address"
}

output "forwarding_rule" {
  value       = google_compute_global_forwarding_rule.default.name
  description = "Name of the forwarding rule"
}
