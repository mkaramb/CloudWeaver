
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

module "example-vpc-module" {
  source                  = "terraform-google-modules/network/google"
  version                 = "~> 6.0"
  project_id              = var.project_id
  network_name            = "vpc-network-${random_string.suffix.result}"
  auto_create_subnetworks = true
  subnets                 = []
}

module "gsuite_export" {
  source  = "terraform-google-modules/gsuite-export/google"
  version = "~> 2.0"

  service_account = var.service_account
  api             = "reports_v1"
  applications    = ["login", "drive", "token"]
  admin_user      = "superadmin@domain.com"
  project_id      = var.project_id
  machine_name    = "gsuite-exporter-simple"
  machine_network = module.example-vpc-module.network_name
}