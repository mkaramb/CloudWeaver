
output "network_name" {
  value       = google_compute_network.vpc_network.name
  description = "The name of the VPC being created"
}

output "network_self_link" {
  value       = google_compute_network.vpc_network.self_link
  description = "The URI of the VPC being created"
}

output "project_id" {
  value       = google_compute_network.vpc_network.project
  description = "VPC project id"
}

output "auto" {
  value       = google_compute_network.vpc_network.auto_create_subnetworks
  description = "The value of the auto mode setting"
}
