
/*********************************************
  Module bigquery_dataset_iam_binding calling
 *********************************************/
module "bigquery_dataset_iam_binding" {
  source  = "terraform-google-modules/iam/google//modules/bigquery_datasets_iam"
  version = "~> 7.0"

  project = var.project_id
  bigquery_datasets = [
    google_bigquery_dataset.bigquery_dataset_one.dataset_id,
  ]
  mode = "authoritative"

  bindings = {
    "roles/bigquery.dataViewer" = [
      "serviceAccount:${var.sa_email}",
      "group:${var.group_email}",
      "user:${var.user_email}",
    ]
    "roles/bigquery.dataEditor" = [
      "serviceAccount:${var.sa_email}",
      "group:${var.group_email}",
      "user:${var.user_email}",
    ]
  }
}

resource "google_bigquery_dataset" "bigquery_dataset_one" {
  project    = var.project_id
  dataset_id = "test_iam_ds_${random_id.test.hex}_one"
}

resource "random_id" "test" {
  byte_length = 4
}
