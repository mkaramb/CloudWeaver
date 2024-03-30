

output "project_id" {
  value       = google_compute_instance.default.project
  description = "Google Cloud project ID"
}

output "instance_self_link" {
  value       = google_compute_instance.default.self_link
  description = "The URI of the instance rule  being created"
}

output "network_name_1" {
  value       = google_compute_instance.default.network_interface[0].network
  description = "The name of the VPC network where the VM's first network interface is created"
}

output "network_name_2" {
  value       = google_compute_instance.default.network_interface[1].network
  description = "The name of the VPC network where the VM's second network interface is created"
}
