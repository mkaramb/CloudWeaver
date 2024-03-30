
output "artifact_bucket" {
  description = "Artifact bucket name"
  value       = google_storage_bucket.artifacts.name
}

output "jobs" {
  description = "List of rendered jobs"
  value       = data.null_data_source.jobs.*.outputs
}
