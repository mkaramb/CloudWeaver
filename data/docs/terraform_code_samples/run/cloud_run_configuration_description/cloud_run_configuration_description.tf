# Example configuration of a Cloud Run service with labels

# [START cloudrun_service_configuration_description]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service-description"
  location = "us-central1"

  description = "This service has a custom description"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }

}
# [END cloudrun_service_configuration_description]
