# [START aiplatform_enable_vertex_ai_api]
# Enable Vertex AI API
resource "google_project_service" "default" {
  service            = "aiplatform.googleapis.com"
  disable_on_destroy = false
}
# [END aiplatform_enable_vertex_ai_api]
