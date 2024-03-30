
output "console_link" {
  description = "The console link to the destination storage bucket"
  value       = "https://console.cloud.google.com/storage/browser/${local.storage_bucket_name}?project=${var.project_id}"
}

output "project" {
  description = "The project in which the storage bucket was created."
  value       = google_storage_bucket.bucket.project
}

output "resource_name" {
  description = "The resource name for the destination storage bucket"
  value       = local.storage_bucket_name
}

output "resource_id" {
  description = "The resource id for the destination storage bucket"
  value       = google_storage_bucket.bucket.id
}

output "self_link" {
  description = "The self_link URI for the destination storage bucket"
  value       = google_storage_bucket.bucket.self_link
}

output "destination_uri" {
  description = "The destination URI for the storage bucket."
  value       = local.destination_uri
}

