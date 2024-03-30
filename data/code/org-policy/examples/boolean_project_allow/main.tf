
/******************************************
  Apply the constraint using the module
 *****************************************/
module "org-policy" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.0"

  policy_for  = "project"
  project_id  = var.project_id
  constraint  = "compute.disableSerialPortAccess"
  policy_type = "boolean"
  enforce     = false
}
