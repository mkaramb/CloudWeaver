
/******************************************
  Module secret_iam_binding calling
 *****************************************/
module "folder-iam" {
  source  = "terraform-google-modules/iam/google//modules/secret_manager_iam"
  version = "~> 7.0"

  project = var.project_id
  secrets = [var.secret_one, var.secret_two]

  mode = "additive"

  bindings = {
    "roles/secretmanager.secretAccessor" = [
      "serviceAccount:${var.sa_email}",
      "group:${var.group_email}",
      "user:${var.user_email}",
    ]

    "roles/secretmanager.viewer" = [
      "user:${var.user_email}",
    ]
  }
}
