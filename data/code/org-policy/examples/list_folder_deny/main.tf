
/******************************************
  Apply the constraint using the module
 *****************************************/
module "org-policy" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.0"

  policy_for       = "folder"
  folder_id        = var.folder_id
  constraint       = "serviceuser.services"
  policy_type      = "list"
  deny             = ["deploymentmanager.googleapis.com"]
  deny_list_length = 1
}
