
locals {
  cidr_list_arg = (
    length(coalesce(var.master_authorized_networks, [])) > 0 ?
    "--master-authorized-networks ${join(",", [for b in var.master_authorized_networks : b.cidr_block])}" : ""
  )

  gcloud_cmd_body = "container clusters update --project=${var.project_id} --zone=${var.zone} ${var.gke_cluster}"
  create_cmd_body = "${local.gcloud_cmd_body} --enable-master-authorized-networks ${local.cidr_list_arg}"
  # At the time of writing the Composer default is to close it to the outside world
  destroy_cmd_body = "${local.gcloud_cmd_body} --enable-master-authorized-networks"
}

module "gcloud" {
  source           = "terraform-google-modules/gcloud/google"
  enabled          = var.master_authorized_networks != null
  version          = "~> 3.1"
  platform         = "linux"
  create_cmd_body  = local.create_cmd_body
  destroy_cmd_body = local.destroy_cmd_body
}
