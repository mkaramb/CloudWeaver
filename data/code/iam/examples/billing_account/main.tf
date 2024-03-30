
locals {
  service_account_01_email = "billing-iam-test-01@${var.project_id}.iam.gserviceaccount.com"
  service_account_02_email = "billing-iam-test-02@${var.project_id}.iam.gserviceaccount.com"

  bindings = {
    "roles/billing.viewer" = [
      "serviceAccount:${local.service_account_01_email}",
    ]

    "roles/billing.admin" = [
      "serviceAccount:${local.service_account_01_email}",
      "serviceAccount:${local.service_account_02_email}",
    ]
  }
}

/******************************************
  Module billing_account_iam_binding calling
 *****************************************/
module "billing-account-iam" {
  source  = "terraform-google-modules/iam/google//modules/billing_accounts_iam"
  version = "~> 7.0"

  billing_account_ids = [var.billing_account_id]

  mode = "additive"

  bindings = local.bindings
}
