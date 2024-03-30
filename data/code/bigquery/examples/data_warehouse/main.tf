
module "data_warehouse" {
  source  = "terraform-google-modules/bigquery/google//modules/data_warehouse"
  version = "~> 7.0"

  project_id          = var.project_id
  region              = "asia-southeast1"
  deletion_protection = false
  force_destroy       = true
}
