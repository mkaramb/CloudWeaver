
module "cloudbuilder" {
  source  = "terraform-google-modules/bootstrap/google//modules/tf_cloudbuild_builder"
  version = "~> 7.0"

  project_id          = module.enabled_google_apis.project_id
  dockerfile_repo_uri = google_sourcerepo_repository.builder_dockerfile_repo.url
  # allow logs bucket to be destroyed
  cb_logs_bucket_force_destroy = true
}

# CSR for storing Dockerfile
resource "google_sourcerepo_repository" "builder_dockerfile_repo" {
  project = module.enabled_google_apis.project_id
  name    = "tf-cloudbuilder"
}

# Bootstrap CSR with Dockerfile
module "bootstrap_csr_repo" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.1"
  upgrade = false

  create_cmd_entrypoint = "${path.module}/scripts/push-to-repo.sh"
  create_cmd_body       = "${module.enabled_google_apis.project_id} ${split("/", google_sourcerepo_repository.builder_dockerfile_repo.id)[3]} ${path.module}/Dockerfile"
}



module "enabled_google_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 14.0"

  project_id                  = var.project_id
  disable_services_on_destroy = false

  activate_apis = [
    "iam.googleapis.com",
    "compute.googleapis.com",
    "sourcerepo.googleapis.com",
    "workflows.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudscheduler.googleapis.com"
  ]
}
