
output "bigquery_datasets" {
  value       = distinct(module.helper.bindings_by_member[*].name)
  description = "Bigquery dataset IDs which received for bindings."
  depends_on  = [google_bigquery_dataset_iam_binding.bigquery_dataset_iam_authoritative, google_bigquery_dataset_iam_member.bigquery_dataset_iam_additive, ]
}

output "roles" {
  value       = distinct(module.helper.bindings_by_member[*].role)
  description = "Roles which were assigned to members."
}

output "members" {
  value       = distinct(module.helper.bindings_by_member[*].member)
  description = "Members which were bound to the bigquery datasets."
}
