# [START cloud_sql_mysql_enterprise_plus_instance_labels]
resource "google_sql_database_instance" "mysql_enterprise_plus_instance_labels" {
  name             = "mysql-enterprise-plus-instance-labels"
  region           = "us-central1"
  database_version = "MYSQL_8_0"
  settings {
    tier    = "db-perf-optimized-N-2"
    edition = "ENTERPRISE_PLUS"
    user_labels = {
      track        = "production"
      billing-code = 34802
    }
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}
# [END cloud_sql_mysql_enterprise_plus_instance_labels]
