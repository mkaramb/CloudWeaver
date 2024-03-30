
output "authorized_views" {
  value       = google_bigquery_dataset_access.authorized_view
  description = "Authorized views for the dataset"
}

output "authorized_roles" {
  value       = google_bigquery_dataset_access.access_role
  description = "Authorized roles for the dataset"
}

output "authorized_dataset" {
  value       = google_bigquery_dataset_access.authorized_dataset
  description = "Authorized datasets for the BQ dataset"
}
