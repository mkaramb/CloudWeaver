
output "keyring" {
  description = "The name of the keyring."
  value       = module.kms.keyring_resource.name
}

output "location" {
  description = "The location of the keyring."
  value       = module.kms.keyring_resource.location
}

output "keys" {
  description = "List of created kkey names."
  value       = keys(module.kms.keys)
}
