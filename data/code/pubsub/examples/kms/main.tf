
provider "google" {
  region = "us-central1"
}

data "google_project" "project" {
  project_id = var.project_id
}

locals {
  pubsub_svc_account_email = "service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

data "google_iam_role" "kms_encrypt_decrypt" {
  name = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
}

resource "google_kms_key_ring" "my_key_ring" {
  name     = "my-key-ring-crqif"
  location = "us-central1"
  project  = var.project_id
}

resource "google_kms_crypto_key" "my_crypto_key" {
  name     = "my-crypto-key-ra5jb"
  key_ring = google_kms_key_ring.my_key_ring.id
}

resource "google_project_iam_member" "project" {
  project = var.project_id
  role    = data.google_iam_role.kms_encrypt_decrypt.name
  member  = "serviceAccount:${local.pubsub_svc_account_email}"
}

module "pubsub" {
  source  = "terraform-google-modules/pubsub/google"
  version = "~> 6.0"

  project_id         = var.project_id
  topic              = var.topic_name
  topic_labels       = var.topic_labels
  topic_kms_key_name = google_kms_crypto_key.my_crypto_key.id

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
    },
  ]
}
