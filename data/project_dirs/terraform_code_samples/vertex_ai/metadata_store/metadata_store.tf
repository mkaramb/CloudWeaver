# [START aiplatform_create_metadata_store_sample]
resource "google_vertex_ai_metadata_store" "default" {
  name        = "${random_id.default.hex}-example-store"
  description = "Example metadata store"
  provider    = google-beta
  region      = "us-central1"
}

resource "random_id" "default" {
  byte_length = 8
}
# [END aiplatform_create_metadata_store_sample]
