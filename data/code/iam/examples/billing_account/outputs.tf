
output "service_account_addresses" {
  value       = [local.service_account_01_email, local.service_account_02_email]
  description = "Service Account Addresses which were bound to projects."
}

output "billing_account_ids" {
  value       = module.billing-account-iam.billing_account_ids
  description = "Billing Accounts which received bindings."
}

output "members" {
  value       = module.billing-account-iam.members
  description = "Members which were bound to the billing accounts."
}
