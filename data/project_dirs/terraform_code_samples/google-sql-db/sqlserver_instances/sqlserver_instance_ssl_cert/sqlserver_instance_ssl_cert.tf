# [START cloud_sql_sqlserver_instance_require_ssl]
resource "google_sql_database_instance" "sqlserver_instance" {
  name             = "sqlserver-instance"
  region           = "asia-northeast1"
  database_version = "SQLSERVER_2019_STANDARD"
  root_password    = "INSERT-PASSWORD-HERE"
  settings {
    tier = "db-custom-2-7680"
    ip_configuration {
      require_ssl = "true"
    }
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}
# [END cloud_sql_sqlserver_instance_require_ssl]
