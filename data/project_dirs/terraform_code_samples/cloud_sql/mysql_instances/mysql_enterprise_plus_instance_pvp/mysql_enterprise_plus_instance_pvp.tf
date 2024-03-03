# [START cloud_sql_mysql_enterprise_plus_instance_pvp]
resource "google_sql_database_instance" "default" {
  name             = "mysql-pvp-enterprise-plus-instance-name"
  region           = "us-central1"
  database_version = "MYSQL_8_0"
  root_password    = "abcABC123!"
  settings {
    tier    = "db-perf-optimized-N-2"
    edition = "ENTERPRISE_PLUS"
    password_validation_policy {
      min_length                  = 6
      complexity                  = "COMPLEXITY_DEFAULT"
      reuse_interval              = 2
      disallow_username_substring = true
      enable_password_policy      = true
    }
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}
# [END cloud_sql_mysql_enterprise_plus_instance_pvp]
