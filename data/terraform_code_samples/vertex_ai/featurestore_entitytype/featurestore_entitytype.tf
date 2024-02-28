# [START aiplatform_create_featurestore_entitytype_sample]
# Featurestore name must be unique for the project
resource "random_id" "featurestore_name_suffix" {
  byte_length = 8
}

resource "google_vertex_ai_featurestore" "featurestore" {
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

output "featurestore_id" {
  value = google_vertex_ai_featurestore.featurestore.id
}

resource "google_vertex_ai_featurestore_entitytype" "entity" {
  name = "featurestore_entitytype"
  labels = {
    environment = "testing"
  }

  featurestore = google_vertex_ai_featurestore.featurestore.id

  monitoring_config {
    snapshot_analysis {
      disabled = false
    }
  }

  depends_on = [google_vertex_ai_featurestore.featurestore]
}
# [END aiplatform_create_featurestore_entitytype_sample]
