
output "project_id" {
  value = var.project_id
}

output "cloudbuild_preview_trigger_id" {
  description = "Trigger used for creating IM previews"
  value       = module.im_workspace.cloudbuild_preview_trigger_id
}

output "cloudbuild_apply_trigger_id" {
  description = "Trigger used for running IM apply"
  value       = module.im_workspace.cloudbuild_apply_trigger_id
}

output "cloudbuild_sa" {
  description = "Service account used by the Cloud Build triggers"
  value       = module.im_workspace.cloudbuild_sa
}

output "infra_manager_sa" {
  description = "Service account used by Infrastructure Manager"
  value       = module.im_workspace.infra_manager_sa
}

output "github_secret_id" {
  description = "The secret ID for the GitHub secret containing the personal access token."
  value       = module.im_workspace.github_secret_id
  sensitive   = true
}
