# [START bigquery_create_table_partitioned]
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

  time_partitioning {
    type          = "DAY"
    field         = "Created"
    expiration_ms = 432000000 # 5 days
  }
  require_partition_filter = true

  schema = <<EOF
[
  {
    "name": "ID",
    "type": "INT64",
    "mode": "NULLABLE",
    "description": "Item ID"
  },
  {
    "name": "Created",
    "type": "TIMESTAMP",
    "description": "Record creation timestamp"
  },
  {
    "name": "Item",
    "type": "STRING",
    "mode": "NULLABLE"
  }
]
EOF

}
# [END bigquery_create_table_partitioned]
