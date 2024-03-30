# Example configuration of a Cloud Run service with request timeout

# [START cloudrun_service_configuration_request_timeout]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service-request-timeout"
  location = "us-central1"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
    # Timeout
    timeout = "300s"
  }
}
# [END cloudrun_service_configuration_request_timeout]
