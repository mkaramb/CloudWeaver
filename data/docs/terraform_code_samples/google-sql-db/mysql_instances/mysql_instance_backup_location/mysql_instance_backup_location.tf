# [START cloud_sql_mysql_instance_backup_location]
resource "google_sql_database_instance" "default" {
  name             = "mysql-instance-with-backup-location"
  region           = "asia-northeast1"
  database_version = "MYSQL_8_0"
  settings {
    tier = "db-f1-micro"
    backup_configuration {
      enabled  = true
      location = "asia-northeast1"
    }
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}
# [END cloud_sql_mysql_instance_backup_location]
