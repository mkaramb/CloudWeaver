# [START cloud_sql_sqlserver_instance_labels]
resource "google_sql_database_instance" "default" {
  name             = "sqlserver-instance-labels"
  region           = "us-central1"
  database_version = "SQLSERVER_2019_STANDARD"
  root_password    = "INSERT-PASSWORD-HERE"
  settings {
    tier = "db-custom-2-7680"
    user_labels = {
      track        = "production"
      billing-code = 34802
    }
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}
# [END cloud_sql_sqlserver_instance_labels]