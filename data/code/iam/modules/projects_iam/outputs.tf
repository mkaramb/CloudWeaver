
output "projects" {
  value       = distinct(module.helper.bindings_by_member[*].name)
  description = "Projects wich received bindings."
  depends_on  = [google_project_iam_binding.project_iam_authoritative, google_project_iam_member.project_iam_additive, ]
}

output "roles" {
  value       = distinct(module.helper.bindings_by_member[*].role)
  description = "Roles which were assigned to members."
}

output "members" {
  value       = distinct(module.helper.bindings_by_member[*].member)
  description = "Members which were bound to projects."
}
