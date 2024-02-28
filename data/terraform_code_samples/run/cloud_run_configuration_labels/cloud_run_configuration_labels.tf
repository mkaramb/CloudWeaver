# Example configuration of a Cloud Run service with labels

# [START cloudrun_service_configuration_labels]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service-labels"
  location = "us-central1"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
    # Labels
    labels = {
      foo : "bar"
      baz : "quux"
    }
  }
}
# [END cloudrun_service_configuration_labels]
