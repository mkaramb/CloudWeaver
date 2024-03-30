
module "runner-mig" {
  source  = "terraform-google-modules/github-actions-runners/google//modules/gh-runner-mig-vm"
  version = "~> 3.0"

  create_network       = true
  project_id           = var.project_id
  repo_name            = var.repo_name
  repo_owner           = var.repo_owner
  gh_token             = var.gh_token
  startup_script       = file("${path.cwd}/startup.sh")
  shutdown_script      = file("${path.cwd}/shutdown.sh")
  source_image_project = var.source_image_project != null ? var.source_image_project : var.project_id
  source_image         = var.source_image
}
