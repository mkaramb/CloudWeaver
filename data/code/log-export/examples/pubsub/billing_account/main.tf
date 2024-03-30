
module "log_export" {
  source  = "terraform-google-modules/log-export/google"
  version = "~> 7.0"

  destination_uri        = module.destination.destination_uri
  log_sink_name          = "pubsub_example_logsink"
  parent_resource_id     = var.parent_resource_id
  parent_resource_type   = "billing_account"
  unique_writer_identity = true
}

module "destination" {
  source  = "terraform-google-modules/log-export/google//modules/pubsub"
  version = "~> 7.0"

  project_id               = var.project_id
  topic_name               = "pubsub-example"
  log_sink_writer_identity = module.log_export.writer_identity
  create_subscriber        = true
}

