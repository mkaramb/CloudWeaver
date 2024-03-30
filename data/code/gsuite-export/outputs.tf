
output "filter" {
  value       = local.export_filter
  description = "Log export filter for logs exported by GSuite-exporter"
}

output "instance_name" {
  value       = google_compute_instance.gsuite_exporter_vm.name
  description = "GSuite Exporter instance name"
}

output "instance_zone" {
  value       = google_compute_instance.gsuite_exporter_vm.zone
  description = "GSuite Exporter instance zone"
}

output "instance_project" {
  value       = google_compute_instance.gsuite_exporter_vm.project
  description = "GSuite Exporter instance project"
}
