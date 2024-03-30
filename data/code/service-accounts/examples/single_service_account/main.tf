
module "service_accounts" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 4.0"

  project_id    = var.project_id
  prefix        = var.prefix
  names         = ["single-account"]
  project_roles = ["${var.project_id}=>roles/viewer"]
  display_name  = "Single Account"
  description   = "Single Account Description"
}

