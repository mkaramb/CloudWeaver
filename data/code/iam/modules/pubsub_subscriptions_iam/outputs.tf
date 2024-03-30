
output "pubsub_subscriptions" {
  value       = distinct(module.helper.bindings_by_member[*].name)
  description = "PubSub Subscriptions which received bindings."
  depends_on  = [google_pubsub_subscription_iam_binding.pubsub_subscription_iam_authoritative, google_pubsub_subscription_iam_member.pubsub_subscription_iam_additive, ]
}

output "roles" {
  value       = distinct(module.helper.bindings_by_member[*].role)
  description = "Roles which were assigned to members."
}

output "members" {
  value       = distinct(module.helper.bindings_by_member[*].member)
  description = "Members which were bound to the PubSub Subscription."
}
