
module "postgresql" {
  source  = "terraform-google-modules/sql-db/google//modules/postgresql"
  version = "~> 18.0"

  name                 = "example-postgres"
  random_instance_name = true
  database_version     = "POSTGRES_9_6"
  project_id           = var.project_id
  zone                 = "us-central1-a"
  region               = "us-central1"
  tier                 = "db-custom-1-3840"

  deletion_protection = false

  ip_configuration = {
    ipv4_enabled        = true
    private_network     = null
    require_ssl         = true
    allocated_ip_range  = null
    authorized_networks = []
  }
}

resource "google_storage_bucket" "backup" {
  name     = "${module.postgresql.instance_name}-backup"
  location = "us-central1"
  # TODO: don't use force_destroy for production this is just required for testing
  force_destroy = true
  project       = var.project_id
}

module "backup" {
  source  = "terraform-google-modules/sql-db/google//modules/backup"
  version = "~> 18.0"

  region                = "us-central1"
  project_id            = var.project_id
  sql_instance          = module.postgresql.instance_name
  export_databases      = []
  export_uri            = google_storage_bucket.backup.url
  backup_retention_time = 1
  backup_schedule       = "5 * * * *"
  export_schedule       = "10 * * * *"
  use_serverless_export = true
  service_account       = "${data.google_project.test_project.number}-compute@developer.gserviceaccount.com"
}

data "google_project" "test_project" {
  project_id = var.project_id
}
