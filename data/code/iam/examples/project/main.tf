
/******************************************
  Module project_iam_binding calling
 *****************************************/
module "project_iam_binding" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 7.0"

  projects = [var.project_one, var.project_two]
  mode     = "additive"

  bindings = {
    "roles/compute.networkAdmin" = [
      "serviceAccount:${var.sa_email}",
      "group:${var.group_email}",
      "user:${var.user_email}",
    ]
    "roles/appengine.appAdmin" = [
      "serviceAccount:${var.sa_email}",
      "group:${var.group_email}",
      "user:${var.user_email}",
    ]
  }
}
