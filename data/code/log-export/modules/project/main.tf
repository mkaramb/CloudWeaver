
locals {
  destination_uri = "logging.googleapis.com/projects/${var.project_id}"
}


#--------------------------------#
# Service account IAM membership #
#--------------------------------#

resource "google_project_iam_member" "log_sink_member" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = var.log_sink_writer_identity
}
