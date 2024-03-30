
output "name" {
  description = "The name of the dataflow job"
  value       = google_dataflow_job.dataflow_job.name
}

output "template_gcs_path" {
  description = "The GCS path to the Dataflow job template."
  value       = google_dataflow_job.dataflow_job.template_gcs_path
}

output "temp_gcs_location" {
  description = "The GCS path for the Dataflow job's temporary data."
  value       = google_dataflow_job.dataflow_job.temp_gcs_location
}

output "state" {
  description = "The state of the newly created Dataflow job"
  value       = google_dataflow_job.dataflow_job.state
}

output "id" {
  description = "The unique Id of the newly created Dataflow job"
  value       = google_dataflow_job.dataflow_job.id
}

