# Example configuration of a Cloud Run service with max instances

# [START cloudrun_service_configuration_max_instances]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service-max-instances"
  location = "us-central1"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
    scaling {
      # Max instances
      max_instance_count = 10
    }
  }
  # [END cloudrun_service_configuration_max_instances]
  lifecycle {
    ignore_changes = [
      template[0].scaling,
    ]
  }
  # [START cloudrun_service_configuration_max_instances]
}
# [END cloudrun_service_configuration_max_instances]
