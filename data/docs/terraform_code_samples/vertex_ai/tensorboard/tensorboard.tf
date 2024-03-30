# [START aiplatform_create_tensorboard_sample]
resource "google_vertex_ai_tensorboard" "default" {
  display_name = "vertex-ai-tensorboard-sample-name"
  region       = "us-central1"
}
# [END aiplatform_create_tensorboard_sample]
