
output "gsuite_export" {
  description = "GSuite Export Module"
  value       = module.gsuite_export
}

output "gsuite_log_export" {
  description = "Log Export Module"
  value       = module.gsuite_log_export
}

output "pubsub" {
  description = "Log Export: PubSub destination submodule"
  value       = module.pubsub
}
