# [START cloud_sql_postgres_instance_ha]
resource "google_sql_database_instance" "postgres_instance_ha" {
  name             = "postgres-instance-ha"
  region           = "us-central1"
  database_version = "POSTGRES_14"
  settings {
    tier              = "db-custom-2-7680"
    availability_type = "REGIONAL"
    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
      start_time                     = "20:55"
    }
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}
# [END cloud_sql_postgres_instance_ha]
