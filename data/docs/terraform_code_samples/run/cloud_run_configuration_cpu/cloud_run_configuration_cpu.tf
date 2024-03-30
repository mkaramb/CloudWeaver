# Example configuration of a Cloud Run service with CPU limit

# [START cloudrun_service_configuration_cpu]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service-cpu"
  location = "us-central1"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      resources {
        limits = {
          # CPU usage limit
          cpu = "1"
        }
      }
    }
  }
  # [END cloudrun_service_configuration_cpu]
  lifecycle {
    ignore_changes = [
      template[0].containers[0].resources[0].limits,
    ]
  }
  # [START cloudrun_service_configuration_cpu]
}

# [END cloudrun_service_configuration_cpu]
