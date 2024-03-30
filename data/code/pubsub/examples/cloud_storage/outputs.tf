
output "project_id" {
  value       = var.project_id
  description = "The project ID"
}

output "bucket_name" {
  value       = google_storage_bucket.test.name
  description = "The name of the Cloud Storage bucket created"
}

output "topic_name" {
  value       = module.pubsub.topic
  description = "The name of the Pub/Sub topic created"
}
