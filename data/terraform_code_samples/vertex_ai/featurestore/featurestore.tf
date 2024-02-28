# [START aiplatform_create_featurestore_sample]
# Featurestore name must be unique for the project
resource "random_id" "featurestore_name_suffix" {
  byte_length = 8
}

resource "google_vertex_ai_featurestore" "main" {
  name   = "featurestore_${random_id.featurestore_name_suffix.hex}"
  region = "us-central1"
  labels = {
    environment = "testing"
  }

  online_serving_config {
    fixed_node_count = 1
  }

  force_destroy = true
}
# [END aiplatform_create_featurestore_sample]
