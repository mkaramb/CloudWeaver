
locals {
  bastion_name = format("%s-bastion", var.cluster_name)
  bastion_zone = format("%s-a", var.region)
}

module "bastion" {
  source  = "terraform-google-modules/bastion-host/google"
  version = "~> 6.0"

  network        = module.vpc.network_self_link
  subnet         = module.vpc.subnets_self_links[0]
  project        = module.enabled_google_apis.project_id
  host_project   = module.enabled_google_apis.project_id
  name           = local.bastion_name
  zone           = local.bastion_zone
  image_project  = "debian-cloud"
  machine_type   = "g1-small"
  startup_script = templatefile("${path.module}/templates/startup-script.tftpl", {})
  members        = var.bastion_members
  shielded_vm    = "false"
}
