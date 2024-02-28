# [START bigquery_create_dataset_iam]
resource "google_bigquery_dataset" "default" {
  dataset_id                      = "mydataset"
  default_partition_expiration_ms = 2592000000  # 30 days
  default_table_expiration_ms     = 31536000000 # 365 days
  description                     = "dataset description"
  location                        = "US"
  max_time_travel_hours           = 96 # 4 days

  labels = {
    billing_group = "accounting",
    pii           = "sensitive"
  }
}

# Update the user, group, or service account
# provided by the members argument with the
# appropriate principals for your organization.
data "google_iam_policy" "default" {
  binding {
    role = "roles/bigquery.dataOwner"
    members = [
      "user:raha@altostrat.com",
    ]
  }
  binding {
    role = "roles/bigquery.admin"
    members = [
      "user:raha@altostrat.com",
    ]
  }
  binding {
    role = "roles/bigquery.user"
    members = [
      "group:analysts@altostrat.com",
    ]
  }
  binding {
    role = "roles/bigquery.dataViewer"
    members = [
      "serviceAccount:bqcx-1234567891011-abcd@gcp-sa-bigquery-condel.iam.gserviceaccount.com",
    ]
  }
}

resource "google_bigquery_dataset_iam_policy" "default" {
  dataset_id  = google_bigquery_dataset.default.dataset_id
  policy_data = data.google_iam_policy.default.policy_data
}
# [END bigquery_create_dataset_iam]
