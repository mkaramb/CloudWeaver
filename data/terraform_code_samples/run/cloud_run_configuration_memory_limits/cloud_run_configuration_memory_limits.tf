# Example configuration of a Cloud Run service with memory limit

# [START cloudrun_service_configuration_memory_limits]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service-memory-limits"
  location = "us-central1"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"

      resources {
        limits = {
          # Memory usage limit (per container)
          memory = "512Mi"
        }
      }
    }
  }
  # [END cloudrun_service_configuration_memory_limits]
  lifecycle {
    ignore_changes = [
      template[0].containers[0].resources[0].limits,
    ]
  }
  # [START cloudrun_service_configuration_memory_limits]
}
# [END cloudrun_service_configuration_memory_limits]
