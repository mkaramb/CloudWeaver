
locals {
  gcloud_cmd_body  = "composer environments run --project=${var.project_id} --location=${var.region} ${var.composer_env_name} pool"
  create_cmd_body  = "${local.gcloud_cmd_body} -- --set ${jsonencode(var.pool_name)} ${jsonencode(var.slot_count)} ${jsonencode(var.description)}"
  destroy_cmd_body = "${local.gcloud_cmd_body} -- --delete ${jsonencode(var.pool_name)}"
}

module "gcloud" {
  source           = "terraform-google-modules/gcloud/google"
  version          = "~> 3.1"
  platform         = "linux"
  create_cmd_body  = local.create_cmd_body
  destroy_cmd_body = local.destroy_cmd_body
}
