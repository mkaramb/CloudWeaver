
output "instances" {
  description = "Instance name => address map."
  value       = zipmap(google_compute_instance.default[*].name, google_compute_address.addresses[*].address)
}

output "password" {
  description = "Auto-generated password, if no password was set as a variable."
  sensitive   = true
  value       = local.use_kms && var.password == "" ? "" : local.password
}
