
output "secrets" {
  value       = distinct(module.helper.bindings_by_member[*].name)
  description = "Secret Manager Secrets which received for bindings."
  depends_on  = [google_secret_manager_secret_iam_binding.secret_manager_iam_authoritative, google_secret_manager_secret_iam_member.secret_manager_iam_additive]
}

output "roles" {
  value       = distinct(module.helper.bindings_by_member[*].role)
  description = "Roles which were assigned to members."
}

output "members" {
  value       = distinct(module.helper.bindings_by_member[*].member)
  description = "Members which were bound to the Secret Manager Secrets."
}
