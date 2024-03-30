
output "cloud_scheduler_job_name" {
  value       = module.bq-log-alerting.name
  description = "The name of the Cloud Scheduler job created"
}

output "pubsub_topic_name" {
  value       = module.bq-log-alerting.pubsub_topic_name
  description = "Pub/Sub topic name"
}

output "cloud_scheduler_job" {
  value       = module.bq-log-alerting.scheduler_job
  description = "The Cloud Scheduler job instance"
}

output "source_name" {
  value       = local.actual_source_name
  description = "The Security Command Center Source name for the \"BQ Log Alerts\" Source"
}

output "cloud_function_service_account_email" {
  value       = google_service_account.gcf_service_account.email
  description = "The email of the service account created to be used by the Cloud Function"
}

output "bq_views_dataset_id" {
  value       = google_bigquery_dataset.views_dataset.id
  description = "The ID of the BigQuery Views dataset"
}
