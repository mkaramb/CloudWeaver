# [START cloudrun_service_deploy_tag]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-srv"
  location = "us-central1"

  template {
    containers {
      # image or tag must be different from previous revision
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
    revision = "cloudrun-srv-blue"
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
    percent  = 0
    revision = "cloudrun-srv-blue"
    tag      = "tag-name"
    type     = "TRAFFIC_TARGET_ALLOCATION_TYPE_REVISION"
  }
}
# [END cloudrun_service_deploy_tag]
