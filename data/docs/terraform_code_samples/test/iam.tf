resource "google_service_account" "int_test" {
  project      = module.projects[0].project_id
  account_id   = "ci-account"
  display_name = "ci-account"
}

resource "google_project_iam_member" "int_test" {
  count = local.num_projects

  project = local.project_ids[count.index]
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.int_test.email}"
}

resource "google_service_account_key" "int_test" {
  service_account_id = google_service_account.int_test.id
}
