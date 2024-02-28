# Example configuration of a Cloud Run service with h2c enabled

# [START cloudrun_service_configuration_h2c]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service-h2c"
  location = "us-central1"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      # Enable HTTP/2
      ports {
        name           = "h2c"
        container_port = 8080
      }
    }
  }
}
# [END cloudrun_service_configuration_h2c]
