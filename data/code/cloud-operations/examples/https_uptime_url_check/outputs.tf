output "uptime_check_id" {
  description = "The id of the uptime check."
  value       = module.uptime-check.uptime_check_id
}

output "alert_policy_id" {
  description = "The id of the alert policy."
  value       = module.uptime-check.alert_policy_id
}

output "notification_channel_ids" {
  description = "The ids of the notification channels"
  value       = module.uptime-check.notification_channel_ids
}
