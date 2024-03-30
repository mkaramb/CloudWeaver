
output "firewall_name" {
  description = "The name of the firewall rule"
  value       = module.iap_firewall.firewall_name
}

output "disk_name" {
  description = "The name of the persistent disk"
  value       = google_compute_disk.main[0].name
}

output "disk_size" {
  description = "The size of the persistent disk"
  value       = google_compute_disk.main[0].size
}

output "instance_name" {
  description = "The instance name"
  value       = google_compute_instance.main.name
}

output "labels" {
  description = "A map of key/value label pairs to assigned to the instance."
  value       = google_compute_instance.main.labels
}
