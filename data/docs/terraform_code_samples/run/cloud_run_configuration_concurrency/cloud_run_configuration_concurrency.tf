# Example configuration of a Cloud Run service with concurrency set

# [START cloudrun_service_configuration_concurrency]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service-concurrency"
  location = "us-central1"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
    # Maximum concurrent requests
    max_instance_request_concurrency = 80
  }
}
# [END cloudrun_service_configuration_concurrency]
