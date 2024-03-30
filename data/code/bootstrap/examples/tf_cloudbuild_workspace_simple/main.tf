
module "tf_workspace" {
  source  = "terraform-google-modules/bootstrap/google//modules/tf_cloudbuild_workspace"
  version = "~> 7.0"

  project_id  = module.enabled_google_apis.project_id
  tf_repo_uri = google_sourcerepo_repository.tf_config_repo.url
  # allow log/state buckets to be destroyed
  buckets_force_destroy = true
  cloudbuild_sa_roles = { (module.enabled_google_apis.project_id) = {
    project_id = module.enabled_google_apis.project_id,
    roles      = ["roles/compute.networkAdmin"]
    }
  }
  cloudbuild_env_vars = ["TF_VAR_project_id=${var.project_id}"]

}

# CSR for storing TF configs
resource "google_sourcerepo_repository" "tf_config_repo" {
  project = module.enabled_google_apis.project_id
  name    = "tf-configs"
}

# # Bootstrap CSR with TF configs
module "bootstrap_csr_repo" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.1"
  upgrade = false

  create_cmd_entrypoint = "${path.module}/scripts/push-to-repo.sh"
  create_cmd_body       = "${module.enabled_google_apis.project_id} ${split("/", google_sourcerepo_repository.tf_config_repo.id)[3]} ${path.module}/files"
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
    "cloudbuild.googleapis.com",
  ]
}
