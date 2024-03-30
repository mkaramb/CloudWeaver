
output "artifact_repo" {
  description = "GAR Repo created to store TF Cloud Builder images"
  value       = module.cloudbuilder.artifact_repo
}

output "workflow_id" {
  description = "Workflow ID for triggering new TF Builder build"
  value       = module.cloudbuilder.workflow_id
}

output "scheduler_id" {
  description = "Scheduler ID for periodically triggering TF Builder build Workflow"
  value       = module.cloudbuilder.scheduler_id
}

output "cloudbuild_trigger_id" {
  description = "Trigger used for building new TF Builder"
  value       = module.cloudbuilder.cloudbuild_trigger_id
}

output "csr_repo_url" {
  description = "CSR repo for storing cloudbuilder Dockerfile"
  value       = google_sourcerepo_repository.builder_dockerfile_repo.url
}

output "project_id" {
  value = var.project_id
}
