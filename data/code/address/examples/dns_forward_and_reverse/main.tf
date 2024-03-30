
provider "google" {
  region = var.region
}

module "address" {
  source  = "terraform-google-modules/address/google"
  version = "~> 3.0"

  project_id         = var.project_id
  region             = var.region
  subnetwork         = var.subnetwork
  enable_cloud_dns   = true
  enable_reverse_dns = true
  dns_domain         = var.dns_domain
  dns_managed_zone   = var.dns_managed_zone
  dns_reverse_zone   = var.dns_reverse_zone
  dns_project        = var.dns_project
  names              = var.names
  dns_short_names    = var.dns_short_names
}

