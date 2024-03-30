# [START cloud_sql_postgres_instance_require_ssl]
resource "google_sql_database_instance" "postgres_instance" {
  name             = "postgres-instance"
  region           = "asia-northeast1"
  database_version = "POSTGRES_14"
  settings {
    tier = "db-custom-2-7680"
    ip_configuration {
      # The following SSL enforcement options only allow connections encrypted with SSL/TLS and with
      # valid client certificates. Please check the API reference for other SSL enforcement options:
      # https://cloud.google.com/sql/docs/postgres/admin-api/rest/v1beta4/instances#ipconfiguration
      require_ssl = "true"
      ssl_mode    = "TRUSTED_CLIENT_CERTIFICATE_REQUIRED"
    }
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}
# [END cloud_sql_postgres_instance_require_ssl]

# [START cloud_sql_postgres_instance_ssl_cert]
resource "google_sql_ssl_cert" "postgres_client_cert" {
  common_name = "postgres_common_name"
  instance    = google_sql_database_instance.postgres_instance.name
}
# [END cloud_sql_postgres_instance_ssl_cert]
