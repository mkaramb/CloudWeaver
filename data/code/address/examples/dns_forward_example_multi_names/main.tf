
locals {
  domain       = "justfortestingmultinames-${random_string.suffix.result}.local"
  forward_zone = "forward-example-multinames"
}

module "address" {
  source  = "terraform-google-modules/address/google"
  version = "~> 3.0"

  project_id       = var.project_id
  region           = var.region
  enable_cloud_dns = true
  dns_domain       = local.domain
  dns_managed_zone = google_dns_managed_zone.forward.name
  dns_project      = var.project_id
  names = [
    "dynamically-reserved-ip-040",
  ]
  dns_short_names = [
    "testip-041",
    "testip-042",
    "testip-043",
  ]
  address_type = "EXTERNAL"
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_dns_managed_zone" "forward" {
  name          = local.forward_zone
  dns_name      = "${local.domain}."
  description   = "DNS forward lookup zone example"
  force_destroy = true
  project       = var.project_id
}
