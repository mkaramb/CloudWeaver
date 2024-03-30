
module "dns-peering-zone" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "~> 5.0"

  project_id                         = var.project_id
  type                               = "peering"
  name                               = var.name
  domain                             = var.domain
  private_visibility_config_networks = [var.network_self_link]
  target_network                     = var.target_network_self_link
  labels                             = var.labels
}
