
/*********************************************
  Module tag_values_iam_binding calling
 *********************************************/
module "tag_values_iam_binding" {
  source  = "terraform-google-modules/iam/google//modules/tag_values_iam"
  version = "~> 7.0"

  tag_values = [
    google_tags_tag_value.tag_value.name,
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
  short_name  = "foo1"
  description = "test tags"
}

resource "google_tags_tag_value" "tag_value" {
  parent      = "tagKeys/${google_tags_tag_key.tag_key.name}"
  short_name  = "bar1"
  description = "Tag value bar."
}
