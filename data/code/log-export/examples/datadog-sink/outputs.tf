
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
  value       = module.destination.pubsub_push_subscription
}

output "datadog_service_account" {
  description = "Datadog service account email"
  value       = local.datadog_svc
}

output "log_writer" {
  value = local.log_writ
}
