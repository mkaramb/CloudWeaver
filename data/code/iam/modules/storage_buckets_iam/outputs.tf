
output "storage_buckets" {
  value       = distinct(module.helper.bindings_by_member[*].name)
  description = "Storage Buckets which received bindings."
  depends_on  = [google_storage_bucket_iam_binding.storage_bucket_iam_authoritative, google_storage_bucket_iam_member.storage_bucket_iam_additive, ]
}

output "roles" {
  value       = distinct(module.helper.bindings_by_member[*].role)
  description = "Roles which were assigned to members."
}

output "members" {
  value       = distinct(module.helper.bindings_by_member[*].member)
  description = "Members which were bound to the Storage Bucket."
}
