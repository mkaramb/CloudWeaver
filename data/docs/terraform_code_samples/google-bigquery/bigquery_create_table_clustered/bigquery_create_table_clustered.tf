# [START bigquery_create_table_clustered]
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

resource "google_bigquery_table" "default" {
  dataset_id          = google_bigquery_dataset.default.dataset_id
  table_id            = "mytable"
  deletion_protection = false # set to "true" in production

  clustering = ["ID", "Created"]

  schema = <<EOF
[
  {
    "name": "ID",
    "type": "INT64",
    "description": "Item ID"
  },
  {
    "name": "Item",
    "type": "STRING",
    "mode": "NULLABLE"
  },
 {
   "name": "Created",
   "type": "TIMESTAMP"
 }
]
EOF

}
# [END bigquery_create_table_clustered]
