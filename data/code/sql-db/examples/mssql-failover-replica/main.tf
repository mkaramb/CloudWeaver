

locals {
  region_1 = "us-central1"
  region_2 = "us-east1"
}

# Instance 1

module "mssql1" {
  source  = "terraform-google-modules/sql-db/google//modules/mssql"
  version = "~> 20.0"

  region = local.region_1

  name                 = "tf-mssql-public-1"
  random_instance_name = true
  project_id           = var.project_id

  database_version = "SQLSERVER_2022_ENTERPRISE"

  deletion_protection = false

  tier = "db-custom-10-65536"

  ip_configuration = {
    ipv4_enabled    = false
    private_network = google_compute_network.default.self_link
  }

  sql_server_audit_config = var.sql_server_audit_config
  enable_default_db       = false
  enable_default_user     = false

  depends_on = [
    google_service_networking_connection.vpc_connection,
  ]
}

# instance 2

module "mssql2" {
  source  = "terraform-google-modules/sql-db/google//modules/mssql"
  version = "~> 20.0"

  master_instance_name = module.mssql1.instance_name

  region = local.region_2

  name                 = "tf-mssql-public-2"
  random_instance_name = true
  project_id           = var.project_id

  database_version = "SQLSERVER_2022_ENTERPRISE"

  deletion_protection = false

  tier = "db-custom-10-65536"

  ip_configuration = {
    ipv4_enabled    = false
    private_network = google_compute_network.default.self_link
  }

  sql_server_audit_config = var.sql_server_audit_config
  enable_default_db       = false
  enable_default_user     = false

  depends_on = [
    google_service_networking_connection.vpc_connection,
  ]
}




# Create Network with a subnetwork and private service access for both netapp.servicenetworking.goog and servicenetworking.googleapis.com

resource "google_compute_network" "default" {
  name                    = var.network_name
  project                 = var.project_id
  auto_create_subnetworks = false
  description             = "test network"
}

resource "google_compute_subnetwork" "subnetwork1" {
  name                     = "subnet-${local.region_1}-mssql"
  ip_cidr_range            = "10.0.0.0/24"
  region                   = local.region_1
  project                  = var.project_id
  network                  = google_compute_network.default.self_link
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "subnetwork_2" {
  name                     = "subnet-${local.region_2}-mssql"
  ip_cidr_range            = "10.0.1.0/24"
  region                   = local.region_2
  project                  = var.project_id
  network                  = google_compute_network.default.self_link
  private_ip_google_access = true
}


resource "google_compute_global_address" "private_ip_alloc" {
  project       = var.project_id
  name          = "psa-mssql"
  address_type  = "INTERNAL"
  purpose       = "VPC_PEERING"
  address       = "10.10.0.0"
  prefix_length = 16
  network       = google_compute_network.default.id
}

resource "google_service_networking_connection" "vpc_connection" {
  network = google_compute_network.default.id
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.private_ip_alloc.name,
  ]
  deletion_policy = "ABANDON"

  depends_on = [
    google_compute_subnetwork.subnetwork1,
    google_compute_subnetwork.subnetwork_2
  ]
}
