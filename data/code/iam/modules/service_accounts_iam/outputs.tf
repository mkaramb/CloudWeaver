
output "service_accounts" {
  value       = distinct(module.helper.bindings_by_member[*].name)
  description = "Service Accounts which received bindings."
  depends_on  = [google_service_account_iam_binding.service_account_iam_authoritative, google_service_account_iam_member.service_account_iam_additive, ]
}

output "roles" {
  value       = distinct(module.helper.bindings_by_member[*].role)
  description = "Roles which were assigned to members."
}

output "members" {
  value       = distinct(module.helper.bindings_by_member[*].member)
  description = "Members which were bound to the Service Account."
}
