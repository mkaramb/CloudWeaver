provider "google" {
  region = "us-central1"
}

# [START aiplatform_create_endpoint_sample]
# Endpoint name must be unique for the project
resource "random_id" "endpoint_id" {
  byte_length = 4
}

resource "google_vertex_ai_endpoint" "default" {
  name         = substr(random_id.endpoint_id.dec, 0, 10)
  display_name = "sample-endpoint"
  description  = "A sample Vertex AI endpoint"
  location     = "us-central1"
  labels = {
    label-one = "value-one"
  }
}
# [END aiplatform_create_endpoint_sample]

