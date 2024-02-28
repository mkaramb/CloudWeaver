# [START cloud_sql_postgres_instance_public_ip]
resource "google_sql_database_instance" "postgres_public_ip_instance_name" {
  database_version = "POSTGRES_14"
  name             = "postgres-public-ip-instance-name"
  region           = "asia-southeast2"
  settings {
    availability_type = "ZONAL"
    ip_configuration {
      # Add optional authorized networks
      # Update to match the customer's networks
      authorized_networks {
        name  = "test-net-3"
        value = "203.0.113.0/24"
      }
      # Enable public IP
      ipv4_enabled = true
    }
    tier = "db-custom-2-7680"
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}
# [END cloud_sql_postgres_instance_public_ip]
