
/******************************************
  Apply the constraint using the module
 *****************************************/
module "org-disable-serial-port-access-deny-all-with-excludes" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.0"

  policy_for      = "organization"
  organization_id = var.organization_id
  constraint      = "compute.disableSerialPortAccess"
  enforce         = true
  policy_type     = "boolean"
  exclude_folders = ["folders/${var.excluded_folder_id}"]
}

