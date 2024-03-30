
/******************************************
  Module organization_iam_binding calling
 *****************************************/
module "organization_iam_binding" {
  source  = "terraform-google-modules/iam/google//modules/organizations_iam"
  version = "~> 7.0"

  organizations = [var.organization_one, var.organization_two]
  mode          = "authoritative"

  bindings = {
    "roles/resourcemanager.organizationViewer" = [
      "serviceAccount:${var.sa_email}",
      "group:${var.group_email}",
      "user:${var.user_email}",
    ]
    "roles/resourcemanager.projectDeleter" = [
      "serviceAccount:${var.sa_email}",
      "group:${var.group_email}",
      "user:${var.user_email}",
    ]
  }
}
