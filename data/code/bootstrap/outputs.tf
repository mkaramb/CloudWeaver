
/******************************************
  Project
*******************************************/

output "seed_project_id" {
  description = "Project where service accounts and core APIs will be enabled."
  value       = module.seed_project.project_id
}

/******************************************
  Service Account
*******************************************/

output "terraform_sa_email" {
  description = "Email for privileged service account for Terraform."
  value       = var.create_terraform_sa ? google_service_account.org_terraform[0].email : ""
  depends_on = [
    google_organization_iam_member.tf_sa_org_perms,
    google_billing_account_iam_member.tf_billing_user,
    google_storage_bucket_iam_member.org_terraform_state_iam,
    google_service_account_iam_member.org_admin_sa_user,
    google_service_account_iam_member.org_admin_sa_impersonate_permissions,
    google_organization_iam_member.org_admin_serviceusage_consumer,
    google_folder_iam_member.org_admin_service_account_user,
    google_folder_iam_member.org_admin_serviceusage_consumer,
    google_storage_bucket_iam_member.orgadmins_state_iam
  ]
}

output "terraform_sa_name" {
  description = "Fully qualified name for privileged service account for Terraform."
  value       = var.create_terraform_sa ? google_service_account.org_terraform[0].name : ""
}

/******************************************
  GCS Terraform State Bucket
*******************************************/

output "gcs_bucket_tfstate" {
  description = "Bucket used for storing terraform state for foundations pipelines in seed project."
  value       = google_storage_bucket.org_terraform_state.name
}
