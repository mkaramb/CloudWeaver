
output "console_link" {
  description = "The console link to the destination storage bucket"
  value       = "https://console.cloud.google.com/cloudpubsub/topics/${local.topic_name}?project=${var.project_id}"
}

output "project" {
  description = "The project in which the topic was created."
  value       = google_pubsub_topic.topic.project
}

output "resource_name" {
  description = "The resource name for the destination topic"
  value       = local.topic_name
}

output "resource_id" {
  description = "The resource id for the destination topic"
  value       = google_pubsub_topic.topic.id
}

output "destination_uri" {
  description = "The destination URI for the topic."
  value       = local.destination_uri
}

output "pubsub_subscriber" {
  description = "Pub/Sub subscriber email (if any)"
  value       = local.pubsub_subscriber
}

output "pubsub_subscription" {
  description = "Pub/Sub subscription id (if any)"
  value       = local.pubsub_subscription
}

output "pubsub_push_subscription" {
  description = "Pub/Sub push subscription id (if any)"
  value       = local.pubsub_push_subscription
}
