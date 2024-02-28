# Example configuration of a Cloud Run service with CPU limit

# [START cloudrun_service_configuration_cpu_allocation]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service-cpu-allocation"
  location = "us-central1"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      resources {
        # If true, garbage-collect CPU when once a request finishes
        cpu_idle = false
      }
    }
  }
}
# [END cloudrun_service_configuration_cpu_allocation]
