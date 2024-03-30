
/******************************************
  Apply the constraint using the module
 *****************************************/
module "org-policy" {
  source  = "terraform-google-modules/org-policy/google"
  version = "~> 5.0"

  policy_for        = "organization"
  organization_id   = var.organization_id
  constraint        = "compute.sharedReservationsOwnerProjects"
  policy_type       = "list"
  allow             = ["projects/${var.shared_reservation_project_id}"]
  allow_list_length = "1"
  exclude_projects  = [var.shared_reservation_project_id]
}
