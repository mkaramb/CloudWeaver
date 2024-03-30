# Example of how to deploy a publicly-accessible Cloud Run application

# [START cloudrun_noauth_parent_tag]
# [START cloudrun_service_noauth]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-srv"
  location = "us-central1"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
}
# [END cloudrun_service_noauth]

# [START cloudrun_service_noauth_iam]
data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_v2_service.default.location
  project  = google_cloud_run_v2_service.default.project
  service  = google_cloud_run_v2_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}
# [END cloudrun_service_noauth_iam]
# [END cloudrun_noauth_parent_tag]
