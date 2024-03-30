
output "lookerstudio_report_url" {
  description = "Looker Studio URL"
  value       = module.data_warehouse.lookerstudio_report_url
}

output "bigquery_editor_url" {
  description = "BQ editor URL"
  value       = module.data_warehouse.bigquery_editor_url
}

output "raw_bucket" {
  description = "Raw bucket name"
  value       = module.data_warehouse.raw_bucket
}
