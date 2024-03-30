
provider "google" {

  project = var.project_id
  region  = var.region
}

resource "google_compute_address" "ip_address" {
  name = "external-ip"
}

locals {
  access_config = {
    nat_ip       = google_compute_address.ip_address.address
    network_tier = "PREMIUM"
  }
}

module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 11.0"

  project_id                   = var.project_id
  subnetwork                   = var.subnetwork
  stack_type                   = "IPV4_ONLY"
  service_account              = var.service_account
  name_prefix                  = "simple"
  tags                         = var.tags
  labels                       = var.labels
  access_config                = [local.access_config]
  enable_nested_virtualization = var.enable_nested_virtualization
  threads_per_core             = var.threads_per_core
}
