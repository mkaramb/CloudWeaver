
locals {
  log_bucket_id   = google_logging_project_bucket_config.bucket.id
  destination_uri = "logging.googleapis.com/${local.log_bucket_id}"
}

#----------------#
# API activation #
#----------------#
resource "google_project_service" "enable_destination_api" {
  project                    = var.project_id
  service                    = "logging.googleapis.com"
  disable_on_destroy         = false
  disable_dependent_services = false
}

#------------#
# Log bucket #
#------------#

resource "google_logging_project_bucket_config" "bucket" {
  project          = google_project_service.enable_destination_api.project
  location         = var.location
  retention_days   = var.retention_days
  enable_analytics = var.enable_analytics
  bucket_id        = var.name
  locked           = var.locked
  dynamic "cmek_settings" {
    for_each = var.kms_key_name == null ? [] : [var.kms_key_name]
    content {
      kms_key_name = var.kms_key_name
    }
  }
}

#-------------------------#
# Linked BigQuery dataset #
#-------------------------#

resource "google_logging_linked_dataset" "linked_dataset" {
  count = var.linked_dataset_id != null ? 1 : 0

  link_id     = var.linked_dataset_id
  description = var.linked_dataset_description
  parent      = "projects/${google_project_service.enable_destination_api.project}"
  bucket      = google_logging_project_bucket_config.bucket.id
  location    = var.location
}

#--------------------------------#
# Service account IAM membership #
#--------------------------------#
resource "google_project_iam_member" "logbucket_sink_member" {
  count = var.grant_write_permission_on_bkt ? 1 : 0

  project = google_logging_project_bucket_config.bucket.project
  role    = "roles/logging.bucketWriter"
  member  = var.log_sink_writer_identity
}
