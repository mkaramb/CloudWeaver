# [START cloud_sql_postgres_enterprise_plus_instance_pvp]
resource "google_sql_database_instance" "default" {
  name             = "postgres-pvp-enterprise-plus-instance-name"
  region           = "asia-northeast1"
  database_version = "POSTGRES_15"
  root_password    = "abcABC123!"
  settings {
    tier    = "db-perf-optimized-N-2"
    edition = "ENTERPRISE_PLUS"
    password_validation_policy {
      min_length                  = 6
      reuse_interval              = 2
      complexity                  = "COMPLEXITY_DEFAULT"
      disallow_username_substring = true
      password_change_interval    = "30s"
      enable_password_policy      = true
    }
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}
# [END cloud_sql_postgres_enterprise_plus_instance_pvp]
