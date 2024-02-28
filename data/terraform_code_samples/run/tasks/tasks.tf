# [START cloudrun_tasks_parent_tag]
# [START cloudrun_service_tasks_service]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloud-run-task-service"
  location = "us-central1"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
}
# [END cloudrun_service_tasks_service]

# [START cloudrun_service_tasks_sa]
resource "google_service_account" "default" {
  account_id   = "cloud-run-task-invoker"
  display_name = "Cloud Run Task Invoker"
}
# [END cloudrun_service_tasks_sa]

# [START cloudrun_service_tasks_run_invoke_permissions]
resource "google_cloud_run_service_iam_binding" "default" {
  location = google_cloud_run_v2_service.default.location
  service  = google_cloud_run_v2_service.default.name
  role     = "roles/run.invoker"
  members  = ["serviceAccount:${google_service_account.default.email}"]
}
# [END cloudrun_service_tasks_run_invoke_permissions]

# [START cloudrun_service_tasks_token_permissions]
resource "google_project_iam_binding" "project_binding" {
  project = google_cloud_run_v2_service.default.project
  role    = "roles/iam.serviceAccountTokenCreator"
  members = ["serviceAccount:${google_service_account.default.email}"]
}
# [END cloudrun_service_tasks_token_permissions]

# [START cloudrun_service_tasks_queue]
resource "google_cloud_tasks_queue" "default" {
  name     = "cloud-tasks-queue-name"
  location = "us-central1"
}
# [END cloudrun_service_tasks_queue]
# [END cloudrun_tasks_parent_tag]
