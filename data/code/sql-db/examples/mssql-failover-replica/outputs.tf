
output "project_id" {
  value = var.project_id
}

# instance 1

output "instance_name1" {
  description = "The name for Cloud SQL instance"
  value       = module.mssql1.instance_name
}

output "mssql_connection" {
  value       = module.mssql1.instance_connection_name
  description = "The connection name of the master instance to be used in connection strings"
}

output "public_ip_address" {
  value       = module.mssql1.instance_first_ip_address
  description = "Public ip address"
}

# instance 2

output "instance_name2" {
  description = "The name for Cloud SQL instance 2"
  value       = module.mssql2.instance_name
}

output "master_instance_name2" {
  value     = module.mssql2.primary.master_instance_name
  sensitive = true
}
