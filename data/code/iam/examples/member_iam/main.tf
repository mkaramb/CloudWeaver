
resource "google_service_account" "member_iam_test" {
  project      = var.project_id
  account_id   = "member-iam-test"
  display_name = "member-iam-test"
}

module "member_roles" {
  source  = "terraform-google-modules/iam/google//modules/member_iam"
  version = "~> 7.0"

  service_account_address = google_service_account.member_iam_test.email
  project_id              = var.project_id
  project_roles           = ["roles/compute.networkAdmin", "roles/appengine.appAdmin"]
  prefix                  = "serviceAccount"
}
