
resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

module "log_export" {
  source  = "terraform-google-modules/log-export/google"
  version = "~> 7.0"

  destination_uri        = module.destination.destination_uri
  filter                 = "resource.type = gce_instance"
  log_sink_name          = "project_${random_string.suffix.result}"
  parent_resource_id     = var.parent_resource_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}

module "destination" {
  source  = "terraform-google-modules/log-export/google//modules/project"
  version = "~> 7.0"

  project_id               = var.project_id
  log_sink_writer_identity = module.log_export.writer_identity
}

