# [START cloudrun_access_control_parent_tag]
# [START cloudrun_service_access_control_run_service]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloud-run-srv"
  location = "us-central1"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
}
# [END cloudrun_service_access_control_run_service]

# [START cloudrun_service_access_control_iam_binding]
resource "google_cloud_run_service_iam_binding" "default" {
  location = google_cloud_run_v2_service.default.location
  service  = google_cloud_run_v2_service.default.name
  role     = "roles/run.invoker"
  members = [
    "allUsers"
  ]
}
# [END cloudrun_service_access_control_iam_binding]
# [END cloudrun_access_control_parent_tag]
