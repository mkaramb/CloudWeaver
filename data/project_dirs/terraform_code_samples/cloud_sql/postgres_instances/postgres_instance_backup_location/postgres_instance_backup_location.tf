# [START cloud_sql_postgres_instance_backup_location]
resource "google_sql_database_instance" "default" {
  name             = "postgres-instance-with-backup-location"
  region           = "us-central1"
  database_version = "POSTGRES_14"
  settings {
    tier = "db-custom-2-7680"
    backup_configuration {
      enabled  = true
      location = "us-central1"
    }
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}
# [END cloud_sql_postgres_instance_backup_location]
