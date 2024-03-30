
locals {
  base_cmd = "${var.membership_name} ${var.membership_location} ${var.membership_project_id} ${coalesce(var.impersonate_service_account, "false")}"
}

module "gcloud_kubectl" {
  source                            = "../.."
  module_depends_on                 = var.module_depends_on
  additional_components             = var.additional_components
  skip_download                     = var.skip_download
  gcloud_sdk_version                = var.gcloud_sdk_version
  enabled                           = var.enabled
  upgrade                           = var.upgrade
  service_account_key_file          = var.service_account_key_file
  use_tf_google_credentials_env_var = var.use_tf_google_credentials_env_var

  create_cmd_entrypoint  = "${path.module}/scripts/kubectl_fleet_wrapper.sh"
  create_cmd_body        = "${local.base_cmd} ${var.kubectl_create_command}"
  create_cmd_triggers    = var.create_cmd_triggers
  destroy_cmd_entrypoint = "${path.module}/scripts/kubectl_fleet_wrapper.sh"
  destroy_cmd_body       = "${local.base_cmd} ${var.kubectl_destroy_command}"
}
