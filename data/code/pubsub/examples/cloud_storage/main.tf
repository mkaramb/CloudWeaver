
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

provider "google" {
  region = "europe-west1"
}

module "pubsub" {
  source  = "terraform-google-modules/pubsub/google"
  version = "~> 6.0"

  project_id = var.project_id
  topic      = "cft-tf-pubsub-topic-cloud-storage"

  topic_labels = {
    foo_label = "foo_value"
  }

  cloud_storage_subscriptions = [
    {
      name   = "example_bucket_subscription"
      bucket = google_storage_bucket.test.name

      ack_deadline_seconds = 300
    },
  ]
}

resource "google_storage_bucket" "test" {
  project  = var.project_id
  name     = join("-", ["test_bucket", random_id.bucket_suffix.hex])
  location = "europe-west1"
}
