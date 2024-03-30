
output "cloudbuild_project_id" {
  description = "Project where CloudBuild configuration and terraform container image will reside."
  value       = module.cloudbuild_project.project_id
}

output "gcs_bucket_cloudbuild_artifacts" {
  description = "Bucket used to store Cloud/Build artifacts in CloudBuild project."
  value       = google_storage_bucket.cloudbuild_artifacts.name
}

output "gcs_bucket_cloudbuild_logs" {
  description = "Bucket used to store Cloud/Build logs in CloudBuild project."
  value       = google_storage_bucket.cloudbuild_logs.name
}

output "csr_repos" {
  description = "List of Cloud Source Repos created by the module, linked to Cloud Build triggers."
  value       = google_sourcerepo_repository.gcp_repo
}

output "tf_runner_artifact_repo" {
  description = "GAR Repo created to store runner images"
  value       = google_artifact_registry_repository.tf-image-repo.name
}
