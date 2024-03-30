
output "gsuite_export" {
  description = "GSuite Export Module"
  value       = module.gsuite_export
}

output "gsuite_log_export" {
  description = "Log Export Module"
  value       = module.gsuite_log_export
}

output "storage" {
  description = "Log Export: Storage destination submodule"
  value       = module.storage
}
