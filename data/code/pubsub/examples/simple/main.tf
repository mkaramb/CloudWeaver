
provider "google" {
  region = "us-central1"
}

module "pubsub" {
  source  = "terraform-google-modules/pubsub/google"
  version = "~> 6.0"

  project_id = var.project_id
  topic      = "cft-tf-pubsub-topic"
  topic_labels = {
    foo_label = "foo_value"
    bar_label = "bar_value"
  }


  pull_subscriptions = [
    {
      name                         = "pull"
      ack_deadline_seconds         = 10
      enable_exactly_once_delivery = true
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

  schema = {
    name       = "example"
    type       = "AVRO"
    encoding   = "JSON"
    definition = "{\n  \"type\" : \"record\",\n  \"name\" : \"Avro\",\n  \"fields\" : [\n    {\n      \"name\" : \"StringField\",\n      \"type\" : \"string\"\n    },\n    {\n      \"name\" : \"IntField\",\n      \"type\" : \"int\"\n    }\n  ]\n}\n"
  }
}
