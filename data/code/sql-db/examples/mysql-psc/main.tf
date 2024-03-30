
locals {
  read_replica_ip_configuration = {
    ipv4_enabled                  = false
    require_ssl                   = false
    psc_enabled                   = true
    psc_allowed_consumer_projects = [var.project_id]
  }

}


module "mysql" {
  source  = "terraform-google-modules/sql-db/google//modules/mysql"
  version = "~> 18.0"

  name                 = var.mysql_ha_name
  random_instance_name = true
  project_id           = var.project_id
  database_version     = "MYSQL_8_0"
  region               = "us-central1"

  deletion_protection = false

  // Master configurations
  tier                            = "db-custom-4-15360"
  zone                            = "us-central1-c"
  availability_type               = "REGIONAL"
  maintenance_window_day          = 7
  maintenance_window_hour         = 12
  maintenance_window_update_track = "stable"

  database_flags = [{ name = "long_query_time", value = 1 }]

  user_labels = {
    foo = "bar"
  }

  ip_configuration = {
    ipv4_enabled                  = false
    psc_enabled                   = true
    psc_allowed_consumer_projects = [var.project_id]
  }

  password_validation_policy_config = {
    enable_password_policy      = true
    complexity                  = "COMPLEXITY_DEFAULT"
    disallow_username_substring = true
    min_length                  = 8
  }

  backup_configuration = {
    enabled                        = true
    binary_log_enabled             = true
    start_time                     = "20:55"
    location                       = null
    transaction_log_retention_days = null
    retained_backups               = 365
    retention_unit                 = "COUNT"
  }

  // Read replica configurations
  read_replica_name_suffix = "-test-psc"
  replica_database_version = "MYSQL_8_0"
  read_replicas = [
    {
      name              = "0"
      zone              = "us-central1-a"
      availability_type = "REGIONAL"
      tier              = "db-custom-4-15360"
      ip_configuration  = local.read_replica_ip_configuration
      database_flags    = [{ name = "long_query_time", value = 1 }]
      disk_type         = "PD_SSD"
      user_labels       = { bar = "baz" }
    },
  ]

  db_name      = var.mysql_ha_name
  db_charset   = "utf8mb4"
  db_collation = "utf8mb4_general_ci"

  additional_databases = [
    {
      name      = "${var.mysql_ha_name}-additional"
      charset   = "utf8mb4"
      collation = "utf8mb4_general_ci"
    },
  ]

  user_name     = "tftest"
  user_password = "Example!12345"
  root_password = ".5nHITPioEJk^k}="

  additional_users = [
    {
      name            = "tftest2"
      password        = "Example!12345"
      host            = "localhost"
      type            = "BUILT_IN"
      random_password = false
    },
    {
      name            = "tftest3"
      password        = "Example!12345"
      host            = "localhost"
      type            = "BUILT_IN"
      random_password = false
    },
  ]
}
