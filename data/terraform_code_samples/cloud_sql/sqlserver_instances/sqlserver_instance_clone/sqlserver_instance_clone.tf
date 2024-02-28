# [START cloud_sql_sqlserver_instance_clone_parent_tag]
# [START cloud_sql_sqlserver_instance_source]
resource "google_sql_database_instance" "source" {
  name             = "sqlserver-instance-source-name"
  region           = "us-central1"
  database_version = "SQLSERVER_2017_STANDARD"
  root_password    = "INSERT-PASSWORD-HERE"
  settings {
    tier = "db-custom-2-7680"
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}
# [END cloud_sql_sqlserver_instance_source]

# [START cloud_sql_sqlserver_instance_clone]
resource "google_sql_database_instance" "clone" {
  name             = "sqlserver-instance-clone-name"
  region           = "us-central1"
  database_version = "SQLSERVER_2017_STANDARD"
  root_password    = "INSERT-PASSWORD-HERE"
  clone {
    source_instance_name = google_sql_database_instance.source.id
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}
# [END cloud_sql_sqlserver_instance_clone]
# [END cloud_sql_sqlserver_instance_clone_parent_tag]
