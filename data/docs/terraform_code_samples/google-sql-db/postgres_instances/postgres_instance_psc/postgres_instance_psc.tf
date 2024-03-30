# [START cloud_sql_postgres_instance_psc]
resource "google_sql_database_instance" "default" {
  name             = "postgres-instance"
  region           = "us-central1"
  database_version = "POSTGRES_14"
  settings {
    tier              = "db-custom-2-7680"
    availability_type = "REGIONAL"
    backup_configuration {
      enabled = true
    }
    ip_configuration {
      psc_config {
        psc_enabled               = true
        allowed_consumer_projects = []
      }
      ipv4_enabled = false
    }
  }
  deletion_protection = false # Set to "true" to prevent destruction of the resource
}
# [END cloud_sql_postgres_instance_psc]

# [START cloud_sql_postgres_instance_psc_endpoint]
resource "google_compute_address" "default" {
  name         = "psc-compute-address"
  region       = "us-central1"
  address_type = "INTERNAL"
  subnetwork   = "default"     # Replace value with the name of the subnet here.
  address      = "10.128.0.42" # Replace value with the IP address to reserve.
}

data "google_sql_database_instance" "default" {
  name = resource.google_sql_database_instance.default.name
}

resource "google_compute_forwarding_rule" "default" {
  name                  = "psc-forwarding-rule-${google_sql_database_instance.default.name}"
  region                = "us-central1"
  network               = "default"
  ip_address            = google_compute_address.default.self_link
  load_balancing_scheme = ""
  target                = data.google_sql_database_instance.default.psc_service_attachment_link
}
# [END cloud_sql_postgres_instance_psc_endpoint]
