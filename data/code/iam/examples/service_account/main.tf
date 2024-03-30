
/******************************************
  Module service_account_iam_binding calling
 *****************************************/
module "service_account_iam_binding" {
  source  = "terraform-google-modules/iam/google//modules/service_accounts_iam"
  version = "~> 7.0"

  service_accounts = [var.service_account_one, var.service_account_two]
  project          = var.service_account_project
  mode             = "additive"
  bindings = {
    "roles/iam.serviceAccountKeyAdmin" = [
      "serviceAccount:${var.sa_email}",
      "group:${var.group_email}",
      "user:${var.user_email}",
    ]
    "roles/iam.serviceAccountTokenCreator" = [
      "serviceAccount:${var.sa_email}",
      "group:${var.group_email}",
      "user:${var.user_email}",
    ]
  }
}
