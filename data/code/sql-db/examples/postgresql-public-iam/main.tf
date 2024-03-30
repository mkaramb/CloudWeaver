

module "postgresql-db" {
  source  = "terraform-google-modules/sql-db/google//modules/postgresql"
  version = "~> 18.0"

  name                 = var.db_name
  random_instance_name = true
  database_version     = "POSTGRES_9_6"
  project_id           = var.project_id
  zone                 = "us-central1-c"
  region               = "us-central1"
  tier                 = "db-custom-1-3840"

  deletion_protection = false

  ip_configuration = {
    ipv4_enabled        = true
    private_network     = null
    require_ssl         = true
    allocated_ip_range  = null
    authorized_networks = var.authorized_networks
  }

  password_validation_policy_config = {
    # Complexity Default - password must contain at least one lowercase, one uppercase, one number and one non-alphanumeric characters.
    complexity                  = "COMPLEXITY_DEFAULT"
    disallow_username_substring = true
    min_length                  = 8
    # Password change interval format is in seconds. 3600s=1h
    password_change_interval = "3600s"
    reuse_interval           = 1
  }
  enable_random_password_special = true

  database_flags = [
    {
      name  = "cloudsql.iam_authentication"
      value = "on"
    },
  ]

  additional_users = [
    {
      name            = "tftest2"
      password        = "Ex@mp!e1"
      host            = "localhost"
      random_password = false
    },
    {
      name            = "tftest3"
      password        = "Ex@mp!e2"
      host            = "localhost"
      random_password = false
    },
  ]

  # Supports creation of both IAM Users and IAM Service Accounts with provided emails
  iam_users = [
    {
      id    = "cloudsql_pg_sa",
      email = var.cloudsql_pg_sa
    },
    {
      id    = "dbadmin",
      email = "dbadmin@develop.blueprints.joonix.net"
    }
  ]
}
