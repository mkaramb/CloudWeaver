
module "mssql" {
  source  = "terraform-google-modules/sql-db/google//modules/mssql"
  version = "~> 18.0"

  name                 = var.name
  random_instance_name = true
  project_id           = var.project_id
  user_name            = "simpleuser"
  user_password        = "foobar"

  deletion_protection = false

  sql_server_audit_config = var.sql_server_audit_config
}
