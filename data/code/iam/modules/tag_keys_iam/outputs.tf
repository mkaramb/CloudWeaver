
output "tag_keys" {
  value       = distinct(module.helper.bindings_by_member[*].name)
  description = "Tag keys which received for bindings."
  depends_on  = [google_tags_tag_key_iam_binding.tag_key_iam_authoritative, google_tags_tag_key_iam_member.tag_key_iam_additive, ]
}

output "roles" {
  value       = distinct(module.helper.bindings_by_member[*].role)
  description = "Roles which were assigned to members."
}

output "members" {
  value       = distinct(module.helper.bindings_by_member[*].member)
  description = "Members which were bound to the Tag keys."
}
