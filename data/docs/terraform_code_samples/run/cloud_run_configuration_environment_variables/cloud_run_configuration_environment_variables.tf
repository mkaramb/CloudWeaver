# Example configuration of a Cloud Run service with environment variables

# [START cloudrun_service_configuration_env_var]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service-env-var"
  location = "us-central1"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"

      # Environment variables
      env {
        name  = "foo"
        value = "bar"
      }
      env {
        name  = "baz"
        value = "quux"
      }
    }
  }
}
# [END cloudrun_service_configuration_env_var]
