# [START cloudrun_service_remove_tag]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-srv"
  location = "us-central1"

  template {}

  # Define the traffic split for each revision
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service#traffic
  traffic {
    percent = 100
    # This revision needs to already exist
    revision = "cloudrun-srv-green"
    type     = "TRAFFIC_TARGET_ALLOCATION_TYPE_REVISION"
  }

  traffic {
    # No tags for this revision
    # Keep revision at 0% traffic
    percent = 0
    # This revision needs to already exist
    revision = "cloudrun-srv-blue"
    type     = "TRAFFIC_TARGET_ALLOCATION_TYPE_REVISION"
  }
}
# [END cloudrun_service_remove_tag]