# [START aiplatform_create_metadata_store_cmek]
resource "google_vertex_ai_metadata_store" "default" {
  name        = "${random_id.default.hex}-example-store"
  description = "Example metadata store"
  provider    = google-beta
  region      = "us-central1"
  encryption_spec {
    kms_key_name = google_kms_crypto_key.default.id
  }

  depends_on = [google_project_iam_member.default]
}

resource "random_id" "default" {
  byte_length = 8
}

resource "google_kms_key_ring" "default" {
  name     = "${random_id.default.hex}-example-keyring"
  location = "us-central1"
}

resource "google_kms_crypto_key" "default" {
  name     = "example-key"
  key_ring = google_kms_key_ring.default.id
}

data "google_project" "default" {
}

# Enable the service account to encrypt/decrypt Cloud KMS keys
resource "google_project_iam_member" "default" {
  project = data.google_project.default.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "serviceAccount:service-${data.google_project.default.number}@gcp-sa-aiplatform.iam.gserviceaccount.com"
}
# [END aiplatform_create_metadata_store_cmek]
