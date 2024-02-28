# [START cloud_sql_postgres_enterprise_plus_instance_clone_parent_tag]
# [START cloud_sql_postgres_enterprise_plus_instance_source]
resource "google_sql_database_instance" "source" {
  name             = "postgres-enterprise-plus-instance-source-name"
  region           = "us-central1"
  database_version = "POSTGRES_15"
  settings {
    tier    = "db-perf-optimized-N-2"
    edition = "ENTERPRISE_PLUS"
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}
# [END cloud_sql_postgres_enterprise_plus_instance_source]

# [START cloud_sql_postgres_enterprise_plus_instance_clone]
resource "google_sql_database_instance" "clone" {
  name             = "postgres-enterprise-plus-instance-clone-name"
  region           = "us-central1"
  database_version = "POSTGRES_15"
  settings {
    tier    = "db-perf-optimized-N-2"
    edition = "ENTERPRISE_PLUS"
  }
  clone {
    source_instance_name = google_sql_database_instance.source.id
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}
# [END cloud_sql_postgres_enterprise_plus_instance_clone]
# [END cloud_sql_postgres_enterprise_plus_instance_clone_parent_tag]
