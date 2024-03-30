
locals {
  destination_uri = "pubsub.googleapis.com/projects/${var.project_id}/topics/${local.topic_name}"
  topic_name      = element(concat(google_pubsub_topic.main[*].name, [""]), 0)
}

module "log_export" {
  source  = "terraform-google-modules/log-export/google"
  version = "~> 8.0"

  destination_uri        = local.destination_uri
  filter                 = var.filter
  log_sink_name          = var.name
  parent_resource_id     = var.project_id
  parent_resource_type   = var.parent_resource_type
  unique_writer_identity = "true"
}

resource "google_pubsub_topic" "main" {
  name    = var.name
  labels  = var.labels
  project = var.project_id
}

resource "google_pubsub_topic_iam_member" "main" {
  topic   = google_pubsub_topic.main.name
  project = var.project_id
  member  = module.log_export.writer_identity
  role    = "roles/pubsub.publisher"
}
