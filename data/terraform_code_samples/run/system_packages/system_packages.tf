# Example of how to deploy a Cloud Run application with system packages

# [START cloudrun_system_packages_parent_tag]
# [START cloudrun_system_packages]
resource "google_service_account" "graphviz" {
  account_id   = "graphviz"
  display_name = "GraphViz Tutorial Service Account"
}

resource "google_cloud_run_v2_service" "default" {
  name     = "graphviz-example"
  location = "us-central1"

  template {
    containers {
      # Replace with the URL of your graphviz image
      #   gcr.io/<YOUR_GCP_PROJECT_ID>/graphviz
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }

    service_account = google_service_account.graphviz.email
  }
}
# [END cloudrun_system_packages]

# [START cloudrun_system_packages_allow_unauthenticated]
# Make Cloud Run service publicly accessible
resource "google_cloud_run_service_iam_member" "allow_unauthenticated" {
  service  = google_cloud_run_v2_service.default.name
  location = google_cloud_run_v2_service.default.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
# [END cloudrun_system_packages_allow_unauthenticated]
# [END cloudrun_system_packages_parent_tag]
