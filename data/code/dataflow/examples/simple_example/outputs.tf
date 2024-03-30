
output "project_id" {
  value       = var.project_id
  description = "The project's ID"
}

output "df_job_state" {
  description = "The state of the newly created Dataflow job"
  value       = module.dataflow-job.state
}

output "df_job_id" {
  description = "The unique Id of the newly created Dataflow job"
  value       = module.dataflow-job.id
}

output "df_job_name" {
  description = "The name of the newly created Dataflow job"
  value       = module.dataflow-job.name
}

output "df_job_state_2" {
  description = "The state of the newly created Dataflow job"
  value       = module.dataflow-job-2.state
}

output "df_job_id_2" {
  description = "The unique Id of the newly created Dataflow job"
  value       = module.dataflow-job-2.id
}

output "df_job_name_2" {
  description = "The name of the newly created Dataflow job"
  value       = module.dataflow-job-2.name
}

output "bucket_name" {
  description = "The name of the bucket"
  value       = module.dataflow-bucket.name
}

