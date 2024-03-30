
resource "google_project_iam_member" "monitoring-log_writer" {
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${var.service_account_email}"
  project = var.project
}

resource "google_project_iam_member" "monitoring-metric_writer" {
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${var.service_account_email}"
  project = var.project
}
