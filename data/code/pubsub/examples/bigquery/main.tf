
provider "google" {
  region = "europe-west1"
}

module "pubsub" {
  source  = "terraform-google-modules/pubsub/google"
  version = "~> 6.0"

  project_id = var.project_id
  topic      = "cft-tf-pubsub-topic-bigquery"
  topic_labels = {
    foo_label = "foo_value"
    bar_label = "bar_value"
  }

  bigquery_subscriptions = [
    {
      name  = "example_subscription"
      table = "${var.project_id}:example_dataset.example_table"
    },
  ]

  depends_on = [
    google_bigquery_table.test
  ]

}

resource "google_bigquery_dataset" "test" {
  project    = var.project_id
  dataset_id = "example_dataset"
  location   = "europe-west1"
}

resource "google_bigquery_table" "test" {
  project             = var.project_id
  deletion_protection = false
  table_id            = "example_table"
  dataset_id          = google_bigquery_dataset.test.dataset_id

  schema = <<EOF
[
  {
    "name": "data",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "The data"
  }
]
EOF
}
