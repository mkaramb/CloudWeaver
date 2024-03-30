
module "tf_source" {
  source  = "terraform-google-modules/bootstrap/google//modules/tf_cloudbuild_source"
  version = "~> 7.0"

  org_id                = var.org_id
  folder_id             = var.parent_folder
  billing_account       = var.billing_account
  group_org_admins      = var.group_org_admins
  buckets_force_destroy = true
}
