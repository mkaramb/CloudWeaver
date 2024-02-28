# [START cloudrun_identity_parent_tag]
# [START cloudrun_service_identity_iam]
resource "google_service_account" "cloudrun_service_identity" {
  account_id = "my-service-account"
}
# [END cloudrun_service_identity_iam]

# [START cloudrun_service_identity_run_service]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloud-run-srv"
  location = "us-central1"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
    service_account = google_service_account.cloudrun_service_identity.email
  }
}
# [END cloudrun_service_identity_run_service]
# [END cloudrun_identity_parent_tag]
