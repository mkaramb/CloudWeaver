
output "project_id" {
  value       = google_compute_subnetwork.network-with-private-secondary-ip-ranges.project
  description = "Google Cloud project ID"
}

output "region" {
  value       = google_compute_subnetwork.network-with-private-secondary-ip-ranges.region
  description = "Google Cloud region"
}

output "subnetwork_name" {
  value       = google_compute_subnetwork.network-with-private-secondary-ip-ranges.name
  description = "The name of the subnetwork"
}

output "primary_cidr" {
  value       = google_compute_subnetwork.network-with-private-secondary-ip-ranges.ip_cidr_range
  description = "Primary CIDR range"
}

output "secondary_cidr_name" {
  value       = google_compute_subnetwork.network-with-private-secondary-ip-ranges.secondary_ip_range[0].range_name
  description = "Name of the secondary CIDR range"
}

output "secondary_cidr" {
  value       = google_compute_subnetwork.network-with-private-secondary-ip-ranges.secondary_ip_range[0].ip_cidr_range
  description = "Secondary CIDR range"
}
