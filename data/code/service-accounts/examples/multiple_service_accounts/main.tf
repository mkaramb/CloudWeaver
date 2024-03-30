
module "service_accounts" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 4.0"

  project_id    = var.project_id
  prefix        = ""
  names         = ["test-first", "test-second"]
  generate_keys = true
  display_name  = "Test Service Accounts"
  description   = "Test Service Accounts description"

  project_roles = [
    "${var.project_id}=>roles/viewer",
    "${var.project_id}=>roles/storage.objectViewer",
  ]
}

