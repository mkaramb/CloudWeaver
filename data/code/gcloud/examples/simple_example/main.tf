
module "cli" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.0"

  platform              = "linux"
  additional_components = ["kubectl", "beta"]

  create_cmd_body  = "services enable youtube.googleapis.com --project ${var.project_id}"
  destroy_cmd_body = "services disable youtube.googleapis.com --project ${var.project_id}"
}

module "cli-disabled" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.0"

  platform              = "linux"
  additional_components = ["kubectl", "beta"]

  enabled          = false
  create_cmd_body  = "services enable datastore.googleapis.com --project ${var.project_id}"
  destroy_cmd_body = "services disable datastore.googleapis.com --project ${var.project_id}"
}
