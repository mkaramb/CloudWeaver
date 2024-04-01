
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
  machine_name    = "gsuite-exporter-bq"
  machine_network = module.example-vpc-module.network_name
}

module "gsuite_log_export" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 7.0"
  destination_uri        = module.bigquery.destination_uri
  filter                 = module.gsuite_export.filter
  log_sink_name          = "gsuite_export_bq"
  parent_resource_id     = var.project_id
  parent_resource_type   = "project"
  unique_writer_identity = false
}

module "bigquery" {
  source                   = "terraform-google-modules/log-export/google//modules/bigquery"
  version                  = "~> 7.0"
  project_id               = var.project_id
  dataset_name             = "my_bigquery_${random_string.suffix.result}"
  log_sink_writer_identity = module.gsuite_log_export.writer_identity
}