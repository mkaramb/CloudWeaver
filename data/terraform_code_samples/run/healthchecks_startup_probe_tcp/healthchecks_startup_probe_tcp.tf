# Enable Cloud Run API
resource "google_project_service" "cloudrun_api" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

# Create Cloud Run Container with TCP startup probe
#[START cloudrun_healthchecks_startup_probe_tcp]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service-healthcheck"
  location = "us-central1"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"

      startup_probe {
        failure_threshold     = 5
        initial_delay_seconds = 10
        timeout_seconds       = 3
        period_seconds        = 3

        tcp_socket {
          port = 8080
        }
      }
    }
  }
}
#[END cloudrun_healthchecks_startup_probe_tcp]
