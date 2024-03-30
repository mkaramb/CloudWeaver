
module "bq-log-alerting" {
  source  = "terraform-google-modules/log-export/google//modules/bq-log-alerting"
  version = "~> 7.0"

  logging_project   = var.logging_project
  bigquery_location = var.bigquery_location
  function_region   = var.function_region
  org_id            = var.org_id
  source_name       = var.source_name
  dry_run           = false
}
