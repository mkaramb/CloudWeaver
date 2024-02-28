# [START cloud_sql_enterprise_plus_instance]
resource "google_sql_database_instance" "default" {
  name             = "enterprise-plus-instance"
  region           = "us-central1"
  database_version = "POSTGRES_15"
  settings {
    tier    = "db-perf-optimized-N-96"
    edition = "ENTERPRISE_PLUS"
  }
  deletion_protection = false
}
# [END cloud_sql_enterprise_plus_instance]
