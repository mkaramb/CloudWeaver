
# Required if using User ADCs (Application Default Credentials) for Cloud Identity API.
# provider "google-beta" {
#   version               = "~> 3.0"
#   user_project_override = true
#   billing_project       = var.project_id
# }

resource "google_service_account" "manager" {
  project      = var.project_id
  account_id   = "example-manager"
  display_name = "example-manager"
}

resource "google_service_account" "member" {
  project      = var.project_id
  account_id   = "example-member"
  display_name = "example-member"
}

module "inner_group" {
  source  = "terraform-google-modules/group/google"
  version = "~> 0.6"

  id           = "group-module-test-inner-group-${var.suffix}@${var.domain}"
  display_name = "group-module-test-inner-group-${var.suffix}"
  description  = "Group module test inner group ${var.suffix}"
  domain       = var.domain
  managers     = ["${google_service_account.manager.account_id}@${var.project_id}.iam.gserviceaccount.com"]
  members      = ["${google_service_account.member.account_id}@${var.project_id}.iam.gserviceaccount.com"]
}

module "group" {
  source  = "terraform-google-modules/group/google"
  version = "~> 0.6"

  id           = "group-module-test-group-${var.suffix}@${var.domain}"
  display_name = "group-module-test-group-${var.suffix}"
  description  = "Group module test group ${var.suffix}"
  domain       = var.domain
  members      = [module.inner_group.id]
}
