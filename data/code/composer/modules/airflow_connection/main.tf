
locals {
  create_parameters = {
    "--conn-extra"    = try(tostring(var.extra), jsonencode(var.extra))
    "--conn-host"     = var.host
    "--conn-login"    = var.login
    "--conn-password" = var.password
    "--conn-port"     = var.port
    "--conn-schema"   = var.schema
    "--conn-type"     = var.type
    "--conn-uri"      = var.uri
  }

  gcloud_cmd_body  = "composer environments run --project=${var.project_id} --location=${var.region} ${var.composer_env_name} connections"
  create_cmd_body  = "${local.gcloud_cmd_body} -- add ${var.id} ${join(" ", [for k, v in local.create_parameters : "${k}=${jsonencode(v)}" if v != null])}"
  destroy_cmd_body = "${local.gcloud_cmd_body} -- delete ${var.id}"
}


module "gcloud" {
  source           = "terraform-google-modules/gcloud/google"
  version          = "~> 3.1"
  platform         = "linux"
  create_cmd_body  = local.create_cmd_body
  destroy_cmd_body = local.destroy_cmd_body
}
