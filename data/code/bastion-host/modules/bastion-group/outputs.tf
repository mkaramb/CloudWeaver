
output "service_account" {
  description = "The email for the service account created for the bastion host"
  value       = module.iap_bastion.service_account
}

output "self_link" {
  description = "Name of the bastion MIG"
  value       = module.mig.self_link
}

output "instance_group" {
  description = "Instance-group url of managed instance group"
  value       = module.mig.instance_group
}
