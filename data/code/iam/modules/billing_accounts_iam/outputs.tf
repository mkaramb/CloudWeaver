
output "billing_account_ids" {
  value       = distinct(module.helper.bindings_by_member[*].name)
  description = "Billing Accounts which received bindings."
  depends_on  = [google_billing_account_iam_binding.billing_account_iam_authoritative, google_billing_account_iam_member.billing_account_iam_additive, ]
}

output "roles" {
  value       = distinct(module.helper.bindings_by_member[*].role)
  description = "Roles which were assigned to members."
}

output "members" {
  value       = distinct(module.helper.bindings_by_member[*].member)
  description = "Members which were bound to the billing accounts."
}
