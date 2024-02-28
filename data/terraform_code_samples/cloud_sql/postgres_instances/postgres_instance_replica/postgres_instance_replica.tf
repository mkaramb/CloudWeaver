# [START cloud_sql_postgres_instance_replica_parent_tag]
# [START cloud_sql_postgres_instance_primary]
resource "google_sql_database_instance" "primary" {
  name             = "postgres-primary-instance-name"
  region           = "europe-west4"
  database_version = "POSTGRES_14"
  settings {
    tier = "db-custom-2-7680"
    backup_configuration {
      enabled = "true"
    }
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}
# [END cloud_sql_postgres_instance_primary]

# [START cloud_sql_postgres_instance_replica]
resource "google_sql_database_instance" "read_replica" {
  name                 = "postgres-replica-instance-name"
  master_instance_name = google_sql_database_instance.primary.name
  region               = "europe-west4"
  database_version     = "POSTGRES_14"

  settings {
    tier              = "db-custom-2-7680"
    availability_type = "ZONAL"
    disk_size         = "100"
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}
# [END cloud_sql_postgres_instance_replica]
# [END cloud_sql_postgres_instance_replica_parent_tag]
