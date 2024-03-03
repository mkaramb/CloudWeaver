# [START cloud_sql_sqlserver_instance_ssm]
resource "google_sql_database_instance" "sqlserver_ssm_instance_name" {
  name                = "sqlserver-ssm-instance-name"
  region              = "asia-northeast1"
  database_version    = "SQLSERVER_2019_STANDARD"
  maintenance_version = "SQLSERVER_2019_STANDARD_CU16_GDR.R20220821.00_00"
  settings {
    tier = "db-f1-micro"
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}
# [END cloud_sql_sqlserver_instance_ssm]
