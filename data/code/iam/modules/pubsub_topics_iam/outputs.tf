
output "pubsub_topics" {
  value       = distinct(module.helper.bindings_by_member[*].name)
  description = "PubSub Topics which received for bindings."
  depends_on  = [google_pubsub_topic_iam_binding.pubsub_topic_iam_authoritative, google_pubsub_topic_iam_member.pubsub_topic_iam_additive, ]
}

output "roles" {
  value       = distinct(module.helper.bindings_by_member[*].role)
  description = "Roles which were assigned to members."
}

output "members" {
  value       = distinct(module.helper.bindings_by_member[*].member)
  description = "Members which were bound to the PubSub Topics."
}
