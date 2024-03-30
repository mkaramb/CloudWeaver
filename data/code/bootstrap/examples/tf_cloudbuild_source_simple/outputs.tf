
output "cloudbuild_project_id" {
  description = "Project where CloudBuild configuration and terraform container image will reside."
  value       = module.tf_source.cloudbuild_project_id
}

output "csr_repos" {
  description = "List of Cloud Source Repos created by the module."
  value       = module.tf_source.csr_repos
}

output "gcs_cloudbuild_default_bucket" {
  description = "Bucket used to store temporary files in CloudBuild project."
  value       = module.tf_source.gcs_cloudbuild_default_bucket
}
