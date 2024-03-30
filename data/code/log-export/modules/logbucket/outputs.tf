
output "console_link" {
  description = "The console link to the destination log buckets"
  value       = "https://console.cloud.google.com/logs/storage?project=${var.project_id}"
}

output "project" {
  description = "The project in which the log bucket was created."
  value       = google_logging_project_bucket_config.bucket.project
}

output "resource_name" {
  description = "The resource name for the destination log bucket"
  value       = google_logging_project_bucket_config.bucket.bucket_id
}

output "destination_uri" {
  description = "The destination URI for the log bucket."
  value       = local.destination_uri
}

output "linked_dataset_name" {
  description = "The resource name of the linked BigQuery dataset."
  value       = var.linked_dataset_id != null ? google_logging_linked_dataset.linked_dataset[0].name : ""
}
