# Example configuration of a Cloud Run service with command and args

# [START cloudrun_service_configuration_containers]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service-containers"
  location = "us-central1"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"

      # Container "entry-point" command
      command = ["/server"]

      # Container "entry-point" args
      args = []
    }
  }
}
# [END cloudrun_service_configuration_containers]
