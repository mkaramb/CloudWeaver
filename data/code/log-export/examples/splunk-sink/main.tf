

module "log_export" {
  source  = "terraform-google-modules/log-export/google"
  version = "~> 7.0"

  destination_uri      = module.destination.destination_uri
  log_sink_name        = "test-splunk-sink"
  parent_resource_id   = var.parent_resource_id
  parent_resource_type = "project"
}

module "destination" {
  source  = "terraform-google-modules/log-export/google//modules/pubsub"
  version = "~> 7.0"

  project_id               = var.project_id
  topic_name               = "splunk-sink"
  log_sink_writer_identity = module.log_export.writer_identity
  create_subscriber        = true
}

resource "google_project_iam_custom_role" "consumer" {
  project     = var.project_id
  role_id     = "SplunkSink"
  title       = "Splunk Sink"
  description = "Grant Splunk Addon for GCP permission to see the project and PubSub Subscription"

  permissions = [
    "pubsub.subscriptions.list",
    "resourcemanager.projects.get",
  ]
}

resource "google_project_iam_member" "consumer" {
  project = var.project_id
  role    = google_project_iam_custom_role.consumer.id
  member  = "serviceAccount:${module.destination.pubsub_subscriber}"
}

resource "google_pubsub_subscription_iam_member" "consumer" {
  project      = var.project_id
  subscription = module.destination.pubsub_subscription
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${module.destination.pubsub_subscriber}"
}
