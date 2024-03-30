
output "cloudbuild_project_id" {
  description = "Project for CloudBuild and Cloud Source Repositories."
  value       = module.cloudbuild_project.project_id

  depends_on = [
    google_storage_bucket_iam_member.cloudbuild_iam,
    google_project_iam_member.org_admins_cloudbuild_editor,
    google_project_iam_member.org_admins_cloudbuild_viewer,
    google_project_iam_member.org_admins_source_repo_admin
  ]
}

output "csr_repos" {
  description = "List of Cloud Source Repos created by the module."
  value       = google_sourcerepo_repository.gcp_repo
}

output "gcs_cloudbuild_default_bucket" {
  description = "Bucket used to store temporary files in CloudBuild project."
  value       = module.cloudbuild_bucket.bucket.name

  depends_on = [
    google_storage_bucket_iam_member.cloudbuild_iam
  ]
}
