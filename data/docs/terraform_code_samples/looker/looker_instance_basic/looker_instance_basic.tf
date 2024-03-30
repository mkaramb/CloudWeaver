# [START looker_google_looker_instance_basic]
# Creates a Standard edition Looker (Google Cloud core) instance with basic functionality enabled.
resource "google_looker_instance" "main" {
  name             = "my-instance"
  platform_edition = "LOOKER_CORE_STANDARD"
  region           = "us-central1"
  oauth_config {
    client_id     = "my-client-id"
    client_secret = "my-client-secret"
  }
}
# [END looker_google_looker_instance_basic]
