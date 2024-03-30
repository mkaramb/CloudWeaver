
module "cli" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.0"

  platform              = "linux"
  additional_components = ["kubectl", "beta"]

  create_cmd_entrypoint = "${path.module}/scripts/script.sh"
  create_cmd_body       = "enable ${var.project_id}"

  destroy_cmd_entrypoint = "${path.module}/scripts/script.sh"
  destroy_cmd_body       = "disable ${var.project_id}"
}
