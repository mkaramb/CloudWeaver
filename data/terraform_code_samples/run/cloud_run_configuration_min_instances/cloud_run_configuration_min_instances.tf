# Example configuration of a Cloud Run service with min instances

# [START cloudrun_service_configuration_min_instances]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service-min-instances"
  location = "us-central1"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
    scaling {
      # Min instances
      min_instance_count = 1
      # [END cloudrun_service_configuration_min_instances]
      # Add to prevent violation: "max_instance_count: must be greater or equal than min_instance_count.""
      max_instance_count = 2
      # [START cloudrun_service_configuration_min_instances]
    }
  }
  # [END cloudrun_service_configuration_min_instances]
  lifecycle {
    ignore_changes = [
      template[0].scaling,
    ]
  }
  # [START cloudrun_service_configuration_min_instances]
}
# [END cloudrun_service_configuration_min_instances]
