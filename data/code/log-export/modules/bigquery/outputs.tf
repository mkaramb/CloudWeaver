
output "console_link" {
  description = "The console link to the destination bigquery dataset"
  value       = "https://bigquery.cloud.google.com/dataset/${var.project_id}:${local.dataset_name}"
}

output "project" {
  description = "The project in which the bigquery dataset was created."
  value       = google_bigquery_dataset.dataset.project
}

output "resource_name" {
  description = "The resource name for the destination bigquery dataset"
  value       = local.dataset_name
}

output "resource_id" {
  description = "The resource id for the destination bigquery dataset"
  value       = google_bigquery_dataset.dataset.id
}

output "self_link" {
  description = "The self_link URI for the destination bigquery dataset"
  value       = google_bigquery_dataset.dataset.self_link
}

output "destination_uri" {
  description = "The destination URI for the bigquery dataset."
  value       = local.destination_uri
}

