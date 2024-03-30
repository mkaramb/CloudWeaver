
/******************************************
  Module cloud_run_service_iam_binding calling
 *****************************************/

module "cloud_run_service_iam_binding" {
  source  = "terraform-google-modules/iam/google//modules/cloud_run_services_iam"
  version = "~> 7.0"

  project            = var.cloud_run_service_project
  location           = var.cloud_run_service_location
  cloud_run_services = [var.cloud_run_service_one, var.cloud_run_service_two]
  mode               = "authoritative"

  bindings = {
    "roles/role.admin" = [
      "serviceAccount:${var.sa_email}",
      "group:${var.group_email}",
      "user:${var.user_email}",
    ]
    "roles/role.invoker" = [
      "serviceAccount:${var.sa_email}",
      "group:${var.group_email}",
      "user:${var.user_email}",
    ]
  }
}
