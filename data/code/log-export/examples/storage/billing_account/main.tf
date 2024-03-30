
module "log_export" {
  source  = "terraform-google-modules/log-export/google"
  version = "~> 7.0"

  destination_uri        = module.destination.destination_uri
  log_sink_name          = "storage_example_logsink"
  parent_resource_id     = var.parent_resource_id
  parent_resource_type   = "billing_account"
  unique_writer_identity = true
}

module "destination" {
  source  = "terraform-google-modules/log-export/google//modules/storage"
  version = "~> 7.0"

  project_id               = var.project_id
  storage_bucket_name      = "storage_example_bucket"
  log_sink_writer_identity = module.log_export.writer_identity
  versioning               = true
}

