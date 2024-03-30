# [START cloud_sql_postgres_instance_pitr]
resource "google_sql_database_instance" "postgres_instance_pitr" {
  name             = ""
  region           = "us-central1"
  database_version = "POSTGRES_14"
  settings {
    tier = "db-custom-2-7680"
    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
      start_time                     = "20:55"
      transaction_log_retention_days = "3"
    }
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}
# [END cloud_sql_postgres_instance_pitr]
