
output "compute_instance_name" {
  value       = google_compute_instance.main.name
  description = "The name of the unlabelled Compute instance."
}

output "project_id" {
  value       = var.project_id
  description = "The ID of the project to which resources are applied."
}

output "zone" {
  value       = var.zone
  description = "The zone in which resources are applied."
}
