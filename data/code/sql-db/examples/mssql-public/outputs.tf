
output "project_id" {
  value = var.project_id
}

output "instance_name" {
  description = "The name for Cloud SQL instance"
  value       = module.mssql.instance_name
}

output "mssql_connection" {
  value       = module.mssql.instance_connection_name
  description = "The connection name of the master instance to be used in connection strings"
}

output "public_ip_address" {
  value       = module.mssql.instance_first_ip_address
  description = "Public ip address"
}
