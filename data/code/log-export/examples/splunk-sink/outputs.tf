
output "pubsub_topic_name" {
  description = "Pub/Sub topic name"
  value       = module.destination.resource_id
}

output "pubsub_topic_project" {
  description = "Pub/Sub topic project id"
  value       = module.destination.project
}

output "pubsub_subscription_name" {
  description = "Pub/Sub topic subscription name"
  value       = module.destination.pubsub_subscription
}

output "pubsub_subscriber" {
  description = "Pub/Sub topic subscriber email"
  value       = module.destination.pubsub_subscriber
}

