# [START cloud_sql_enterprise_instance]
resource "google_sql_database_instance" "default" {
  name             = "enterprise-instance"
  region           = "us-central1"
  database_version = "POSTGRES_15"
  settings {
    tier = "db-g1-small"
  }
  deletion_protection = "false"
}
# [END cloud_sql_enterprise_instance]
