
module "mysql" {
  source  = "terraform-google-modules/sql-db/google//modules/mysql"
  version = "~> 18.0"

  name                 = "example-mysql-public"
  database_version     = "MYSQL_8_0"
  random_instance_name = true
  project_id           = var.project_id
  zone                 = "us-central1-a"
  region               = "us-central1"
  deletion_protection  = false

  ip_configuration = {
    ipv4_enabled        = true
    private_network     = null
    require_ssl         = true
    allocated_ip_range  = null
    authorized_networks = []
  }
}

resource "google_storage_bucket" "backup" {
  name     = "${module.mysql.instance_name}-backup"
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
  sql_instance          = module.mysql.instance_name
  export_databases      = []
  export_uri            = google_storage_bucket.backup.url
  backup_retention_time = 1
  backup_schedule       = "5 * * * *"
  export_schedule       = "10 * * * *"
  compress_export       = false
}
