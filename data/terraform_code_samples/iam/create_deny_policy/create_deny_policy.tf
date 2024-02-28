# Google Cloud Documentation: https://cloud.google.com/iam/docs/deny-access#create-deny-policy
# Hashicorp Documentation: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_deny_policy

# [START iam_create_deny_policy]
data "google_project" "default" {
}

# Create a service account
resource "google_service_account" "default" {
  display_name = "IAM Deny Example - Service Account"
  account_id   = "example-sa"
  project      = data.google_project.default.project_id
}

# Create an IAM deny policy that denies a permission for the service account
resource "google_iam_deny_policy" "default" {
  provider     = google-beta
  parent       = urlencode("cloudresourcemanager.googleapis.com/projects/${data.google_project.default.project_id}")
  name         = "my-deny-policy"
  display_name = "My deny policy."
  rules {
    deny_rule {
      denied_principals  = ["principal://iam.googleapis.com/projects/-/serviceAccounts/${google_service_account.default.email}"]
      denied_permissions = ["iam.googleapis.com/roles.create"]
    }
  }
}
# [END iam_create_deny_policy]
