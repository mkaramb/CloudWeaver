
module "im_workspace" {
  source = "../../modules/im_cloudbuild_workspace"

  project_id    = var.project_id
  deployment_id = "im-example-gitlab-deployment"

  tf_repo_type           = "GITLAB"
  im_deployment_repo_uri = var.repository_url
  im_deployment_ref      = "main"
  im_tf_variables        = "project_id=${var.project_id}"
  infra_manager_sa_roles = ["roles/compute.networkAdmin"]
  tf_version             = "1.2.3"

  gitlab_api_access_token      = var.im_gitlab_pat
  gitlab_read_api_access_token = var.im_gitlab_pat
}



module "enabled_google_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 14.0"

  project_id                  = var.project_id
  disable_services_on_destroy = false

  activate_apis = [
    "iam.googleapis.com",
    "compute.googleapis.com",
    "cloudbuild.googleapis.com",
    "config.googleapis.com",
  ]
}
