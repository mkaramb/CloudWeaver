
output "folders" {
  value       = distinct(module.helper.bindings_by_member[*].name)
  description = "Folders which received bindings."
  depends_on  = [google_folder_iam_binding.folder_iam_authoritative, google_folder_iam_member.folder_iam_additive, ]
}

output "roles" {
  value       = distinct(module.helper.bindings_by_member[*].role)
  description = "Roles which were assigned to members."
}

output "members" {
  value       = distinct(module.helper.bindings_by_member[*].member)
  description = "Members which were bound to the folders."
}
