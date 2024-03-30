
output "topic" {
  value       = length(google_pubsub_topic.topic) > 0 ? google_pubsub_topic.topic[0].name : ""
  description = "The name of the Pub/Sub topic"
}

output "topic_labels" {
  value       = length(google_pubsub_topic.topic) > 0 ? google_pubsub_topic.topic[0].labels : {}
  description = "Labels assigned to the Pub/Sub topic"
}

output "id" {
  value       = length(google_pubsub_topic.topic) > 0 ? google_pubsub_topic.topic[0].id : ""
  description = "The ID of the Pub/Sub topic"
}

output "uri" {
  value       = length(google_pubsub_topic.topic) > 0 ? "pubsub.googleapis.com/${google_pubsub_topic.topic[0].id}" : ""
  description = "The URI of the Pub/Sub topic"
}

output "subscription_names" {
  value = concat(
    values({ for k, v in google_pubsub_subscription.push_subscriptions : k => v.name }),
    values({ for k, v in google_pubsub_subscription.pull_subscriptions : k => v.name }),
    values({ for k, v in google_pubsub_subscription.bigquery_subscriptions : k => v.name }),
    values({ for k, v in google_pubsub_subscription.cloud_storage_subscriptions : k => v.name }),
  )

  description = "The name list of Pub/Sub subscriptions"
}

output "subscription_paths" {
  value = concat(
    values({ for k, v in google_pubsub_subscription.push_subscriptions : k => v.id }),
    values({ for k, v in google_pubsub_subscription.pull_subscriptions : k => v.id }),
    values({ for k, v in google_pubsub_subscription.bigquery_subscriptions : k => v.name }),
    values({ for k, v in google_pubsub_subscription.cloud_storage_subscriptions : k => v.name }),
  )

  description = "The path list of Pub/Sub subscriptions"
}

