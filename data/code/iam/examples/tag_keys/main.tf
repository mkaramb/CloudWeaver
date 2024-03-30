
/*********************************************
  Module tag_keys_iam_binding calling
 *********************************************/
module "tag_keys_iam_binding" {
  source  = "terraform-google-modules/iam/google//modules/tag_keys_iam"
  version = "~> 7.0"

  tag_keys = [
    google_tags_tag_key.tag_key.name,
  ]
  mode = "authoritative"

  bindings = {
    "roles/viewer" = [
      "serviceAccount:${var.sa_email}",
      "group:${var.group_email}",
      "user:${var.user_email}",
    ]
  }
}

data "google_project" "project" {
  project_id = var.project_id
}

resource "google_tags_tag_key" "tag_key" {
  parent      = "projects/${data.google_project.project.number}"
  short_name  = "foo"
  description = "test tags"
}
