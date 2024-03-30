
output "ds_friendly_name" {
  value       = google_bigquery_dataset.ds_edw.friendly_name
  description = "Dataset name"
}

output "raw_bucket" {
  value       = google_storage_bucket.raw_bucket.name
  description = "Raw bucket name"
}

output "lookerstudio_report_url" {
  value       = "https://lookerstudio.google.com/reporting/create?c.reportId=8a6517b8-8fcd-47a2-a953-9d4fb9ae4794&ds.ds_profit.datasourceName=lookerstudio_report_profit&ds.ds_profit.projectId=${module.project-services.project_id}&ds.ds_profit.type=TABLE&ds.ds_profit.datasetId=${google_bigquery_dataset.ds_edw.dataset_id}&ds.ds_profit.tableId=lookerstudio_report_profit&ds.ds_dc.datasourceName=lookerstudio_report_distribution_centers&ds.ds_dc.projectId=${module.project-services.project_id}&ds.ds_dc.type=TABLE&ds.ds_dc.datasetId=${google_bigquery_dataset.ds_edw.dataset_id}&ds.ds_dc.tableId=lookerstudio_report_distribution_centers"
  description = "The URL to create a new Looker Studio report displays a sample dashboard for the e-commerce data analysis"
}

output "bigquery_editor_url" {
  value       = "https://console.cloud.google.com/bigquery?project=${module.project-services.project_id}&ws=!1m5!1m4!6m3!1s${module.project-services.project_id}!2s${google_bigquery_dataset.ds_edw.dataset_id}!3ssp_sample_queries"
  description = "The URL to launch the BigQuery editor with the sample query procedure opened"
}

output "neos_tutorial_url" {
  value       = "https://console.cloud.google.com/products/solutions/deployments?walkthrough_id=panels--sic--data-warehouse_toc"
  description = "The URL to launch the in-console tutorial for the EDW solution"
}
