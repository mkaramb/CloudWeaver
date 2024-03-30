
/******************************************
  Module folder_iam_binding calling
 *****************************************/
module "folder-iam" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.0"

  folders = [var.folder_one, var.folder_two]

  mode = "additive"

  bindings = {
    "roles/resourcemanager.folderEditor" = [
      "serviceAccount:${var.sa_email}",
      "group:${var.group_email}",
    ]

    "roles/resourcemanager.folderViewer" = [
      "user:${var.user_email}",
    ]
  }
}
