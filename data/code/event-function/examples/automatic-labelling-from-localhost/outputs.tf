
output "compute_instance_name" {
  value       = google_compute_instance.main.name
  description = "The name of the unlabelled Compute instance."
}
