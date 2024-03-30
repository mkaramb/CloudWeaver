
/*************************************************
  Bootstrap GCP Folder.
*************************************************/

module "seed_bootstrap" {
  source  = "terraform-google-modules/bootstrap/google"
  version = "~> 7.0"

  org_id               = var.org_id
  parent_folder        = var.parent
  billing_account      = var.billing_account
  group_org_admins     = var.group_org_admins
  group_billing_admins = var.group_billing_admins
  default_region       = var.default_region
  org_project_creators = var.org_project_creators
  project_prefix       = var.project_prefix
}
