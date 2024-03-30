
output "project_id" {
  value       = var.project_id
  description = "The project ID"
}

output "topic_name" {
  value       = module.pubsub.topic
  description = "The name of the Pub/Sub topic created"
}

output "topic_labels" {
  value       = module.pubsub.topic_labels
  description = "The labels of the Pub/Sub topic created"
}
