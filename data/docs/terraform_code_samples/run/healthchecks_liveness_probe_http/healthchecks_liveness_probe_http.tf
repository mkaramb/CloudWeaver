# Enable Cloud Run API
resource "google_project_service" "cloudrun_api" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

# Create Cloud Run Container with HTTP liveness probe
#[START cloudrun_healthchecks_liveness_probe_http]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service-healthcheck"
  location = "us-central1"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"

      liveness_probe {
        failure_threshold     = 5
        initial_delay_seconds = 10
        timeout_seconds       = 3
        period_seconds        = 3

        http_get {
          path = "/"
          # Custom headers to set in the request
          # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service#http_headers
          http_headers {
            name  = "Access-Control-Allow-Origin"
            value = "*"
          }
        }
      }
    }
  }
}
#[END cloudrun_healthchecks_liveness_probe_http]
