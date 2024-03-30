
output "bigquery_dataset" {
  value       = module.bigquery.bigquery_dataset
  description = "Bigquery dataset resource."
}

output "bigquery_tables" {
  value       = module.bigquery.bigquery_tables
  description = "Map of bigquery table resources being provisioned."
}

output "bigquery_external_tables" {
  value       = module.bigquery.bigquery_external_tables
  description = "Map of bigquery table resources being provisioned."
}

output "bigquery_auth_dataset" {
  value       = module.auth_dataset.bigquery_dataset
  description = "Authorized Bigquery dataset resource."
}

output "authorization" {
  value       = module.add_authorization.authorized_dataset["${module.auth_dataset.bigquery_dataset.project}_${module.auth_dataset.bigquery_dataset.dataset_id}"]
  description = "Authorization Bigquery dataset resource."
}
