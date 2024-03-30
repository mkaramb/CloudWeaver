
output "bigquery_dataset" {
  value       = module.bigquery_tables.bigquery_dataset
  description = "Bigquery dataset resource."
}

output "bigquery_tables" {
  value       = module.bigquery_tables.bigquery_tables
  description = "Map of bigquery table resources being provisioned."
}

output "bigquery_dataset_view" {
  value       = module.bigquery_views_without_pii.bigquery_dataset
  description = "Bigquery dataset resource."
}

output "bigquery_views" {
  value       = module.bigquery_views_without_pii.bigquery_views
  description = "Map of bigquery table/view resources being provisioned."
}

output "authorized_views" {
  value       = module.authorization.authorized_views
  description = "Map of authorized views created"
}

output "access_roles" {
  value       = module.authorization.authorized_roles
  description = "Map of roles assigned to identities"
}
