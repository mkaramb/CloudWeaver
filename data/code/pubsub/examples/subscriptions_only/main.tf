
provider "google" {
  region = "us-central1"
}

resource "google_pubsub_topic" "example" {
  name    = "terraform-test-topic"
  project = var.topic_project

}
module "pubsub" {
  source  = "terraform-google-modules/pubsub/google"
  version = "~> 6.0"

  project_id           = var.project_id
  create_topic         = false
  create_subscriptions = true
  topic                = google_pubsub_topic.example.id


  pull_subscriptions = [
    {
      name                 = "pull"
      ack_deadline_seconds = 10
    },
  ]

  push_subscriptions = [
    {
      name                 = "push"
      push_endpoint        = "https://${var.project_id}.appspot.com/"
      x-goog-version       = "v1beta1"
      ack_deadline_seconds = 20
      expiration_policy    = "1209600s" // two weeks
    },
  ]

}
