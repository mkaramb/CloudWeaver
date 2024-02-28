# [START cloudrun_service_traffic_split]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-srv"
  location = "us-central1"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
    revision = "cloudrun-srv-green"
  }

  # Define the traffic split for each revision
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service#traffic
  traffic {
    percent  = 25
    revision = "cloudrun-srv-green"
    type     = "TRAFFIC_TARGET_ALLOCATION_TYPE_REVISION"
  }

  traffic {
    percent = 75
    # This revision needs to already exist
    revision = "cloudrun-srv-blue"
    type     = "TRAFFIC_TARGET_ALLOCATION_TYPE_REVISION"
  }
}
# [END cloudrun_service_traffic_split]
