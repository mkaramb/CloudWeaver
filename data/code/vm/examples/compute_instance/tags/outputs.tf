

output "network_name" {
  value       = google_compute_instance.default.network_interface[0].network
  description = "The name of the VPC network where the VM instance is created"
}

output "instance_self_link" {
  value       = google_compute_instance.default.self_link
  description = "The URI of the instance rule  being created"
}

output "tags" {
  value       = google_compute_instance.default.tags
  description = "Tags added to VM instance"
}

output "project_id" {
  value       = google_compute_instance.default.project
  description = "Google Cloud project ID"
}
