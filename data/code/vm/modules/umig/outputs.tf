
output "self_links" {
  description = "List of self-links for unmanaged instance groups"
  value       = google_compute_instance_group.instance_group[*].self_link
}

output "umig_details" {
  description = "List of all details for unmanaged instance groups"
  value       = google_compute_instance_group.instance_group[*]
}

output "instances_self_links" {
  description = "List of self-links for compute instances"
  value       = google_compute_instance_from_template.compute_instance[*].self_link
}

output "instances_details" {
  description = "List of all details for compute instances"
  value       = google_compute_instance_from_template.compute_instance[*]
}

output "available_zones" {
  description = "List of available zones in region"
  value       = data.google_compute_zones.available.names
}
