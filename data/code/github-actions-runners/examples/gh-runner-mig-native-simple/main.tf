
module "runner-mig" {
  source  = "terraform-google-modules/github-actions-runners/google//modules/gh-runner-mig-vm"
  version = "~> 3.0"

  create_network = true
  project_id     = var.project_id
  repo_name      = var.repo_name
  repo_owner     = var.repo_owner
  gh_token       = var.gh_token
}
