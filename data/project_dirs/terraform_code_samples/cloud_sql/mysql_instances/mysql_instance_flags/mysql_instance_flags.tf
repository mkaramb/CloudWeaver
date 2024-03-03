# [START cloud_sql_mysql_instance_flags]
resource "google_sql_database_instance" "instance" {
  database_version = "MYSQL_8_0"
  name             = "mysql-instance"
  region           = "us-central1"
  settings {
    database_flags {
      name  = "general_log"
      value = "on"
    }
    database_flags {
      name  = "skip_show_database"
      value = "on"
    }
    database_flags {
      name  = "wait_timeout"
      value = "200000"
    }
    disk_type = "PD_SSD"
    tier      = "db-n1-standard-2"
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}
# [END cloud_sql_mysql_instance_flags]
