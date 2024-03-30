# [START cloudrun_service_traffic_split_tag]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-srv"
  location = "us-central1"

  template {}

  # Define the traffic split for each revision
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service#traffic
  traffic {
    # Update revision to 50% traffic
    percent = 50
    # This revision needs to already exist
    revision = "cloudrun-srv-green"
    type     = "TRAFFIC_TARGET_ALLOCATION_TYPE_REVISION"
  }

  traffic {
    # Update tag to 50% traffic
    percent = 50
    # This tag needs to already exist
    tag = "tag-name"
  }
}
# [END cloudrun_service_traffic_split_tag]
