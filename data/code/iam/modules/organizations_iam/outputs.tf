
output "organizations" {
  value       = distinct(module.helper.bindings_by_member[*].name)
  description = "Organizations which received bindings."
  depends_on  = [google_organization_iam_binding.organization_iam_authoritative, google_organization_iam_member.organization_iam_additive, ]
}

output "roles" {
  value       = distinct(module.helper.bindings_by_member[*].role)
  description = "Roles which were assigned to members."
}

output "members" {
  value       = distinct(module.helper.bindings_by_member[*].member)
  description = "Members which were bound to organizations."
}
