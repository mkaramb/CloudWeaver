# [START cloudrun_service_traffic_gradual_rollout]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-srv"
  location = "us-central1"

  template {
    containers {
      # Image or image tag must be different from previous revision
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }

  # Define the traffic split for each revision
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service#traffic
  traffic {
    percent = 100
    # This revision needs to already exist
    revision = "cloudrun-srv-green"
    type     = "TRAFFIC_TARGET_ALLOCATION_TYPE_REVISION"
  }

  traffic {
    # Deploy new revision with 0% traffic
    percent = 0
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
  }
}
# [END cloudrun_service_traffic_gradual_rollout]
