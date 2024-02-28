# [START cloudrun_service_traffic_rollback]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-srv"
  location = "us-central1"

  template {}

  traffic {
    percent = 100
    # This revision needs to already exist
    revision = "cloudrun-srv-green"
    type     = "TRAFFIC_TARGET_ALLOCATION_TYPE_REVISION"

  }
}
# [END cloudrun_service_traffic_rollback]
