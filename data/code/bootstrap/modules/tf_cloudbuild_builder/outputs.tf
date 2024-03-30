
output "artifact_repo" {
  description = "GAR Repo created to store TF Cloud Builder images"
  value       = google_artifact_registry_repository.tf-image-repo.name
}

output "workflow_id" {
  description = "Workflow ID for triggering new TF Builder build"
  value       = google_workflows_workflow.builder.id
}

output "workflow_sa" {
  description = "SA used by Workflow for triggering new TF Builder build"
  value       = local.workflow_sa
}

output "scheduler_id" {
  description = "Scheduler ID for periodically triggering TF Builder build Workflow"
  value       = google_cloud_scheduler_job.trigger_workflow.id
}

output "cloudbuild_trigger_id" {
  description = "Trigger used for building new TF Builder"
  value       = google_cloudbuild_trigger.build_trigger.id
}

output "cloudbuild_sa" {
  description = "SA used by Cloud Build trigger"
  value       = local.cloudbuild_sa
}
