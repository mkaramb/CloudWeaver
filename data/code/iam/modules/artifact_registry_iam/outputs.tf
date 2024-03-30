
output "repositories" {
  value       = distinct(module.helper.bindings_by_member[*].name)
  description = "Artifact registry repositories which received bindings."
  depends_on  = [google_artifact_registry_repository_iam_binding.artifact_registry_iam_authoritative, google_artifact_registry_repository_iam_member.artifact_registry_iam_additive, ]
}

output "roles" {
  value       = distinct(module.helper.bindings_by_member[*].role)
  description = "Roles which were assigned to members."
}

output "members" {
  value       = distinct(module.helper.bindings_by_member[*].member)
  description = "Members which were bound to artifact registry repositories."
}
