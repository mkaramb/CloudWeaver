
output "project" {
  value       = google_compute_shared_vpc_host_project.host.project
  description = "Host project ID"
}

output "ip_address_name" {
  value       = google_compute_address.internal.name
  description = "The name of the internal IP"
}

output "subnet" {
  value       = google_compute_address.internal.subnetwork
  description = "Name of the host subnet"
}

output "ip_address" {
  value       = google_compute_address.internal.address
  description = "The internal IP address"
}
