# [START cloudrun_traffic_latest_revision_parent_tag]
# [START cloudrun_service_traffic_latest]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-srv"
  location = "us-central1"

  template {}

  traffic {
    percent = 100
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
  }
}
# [END cloudrun_service_traffic_latest]
# [END cloudrun_traffic_latest_revision_parent_tag]
