
locals {
  gar_name = split("/", google_artifact_registry_repository.tf-image-repo.name)[length(split("/", google_artifact_registry_repository.tf-image-repo.name)) - 1]
}

resource "google_artifact_registry_repository" "tf-image-repo" {
  provider = google-beta
  project  = var.project_id

  location      = var.gar_repo_location
  repository_id = var.gar_repo_name
  description   = "Docker repository for Terraform runner images used by Cloud Build. Managed by Terraform."
  format        = "DOCKER"
}

# Grant CB SA permissions to push to repo
resource "google_artifact_registry_repository_iam_member" "push_images" {
  provider = google-beta
  project  = var.project_id

  location   = google_artifact_registry_repository.tf-image-repo.location
  repository = google_artifact_registry_repository.tf-image-repo.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${local.cloudbuild_sa_email}"
}

# Grant Workflows SA access to list images in the artifact repo
resource "google_artifact_registry_repository_iam_member" "workflow_list" {
  provider = google-beta
  project  = var.project_id

  location   = google_artifact_registry_repository.tf-image-repo.location
  repository = google_artifact_registry_repository.tf-image-repo.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${local.workflow_sa}"
}
