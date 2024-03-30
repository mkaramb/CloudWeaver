
output "project_id" {
  value       = var.project_id
  description = "The project to run tests against"
}

output "name" {
  description = "The name for Cloud SQL instance"
  value       = module.safer-mysql-db.instance_name
}

output "mysql_conn" {
  value       = module.safer-mysql-db.instance_connection_name
  description = "The connection name of the master instance to be used in connection strings"
}

output "mysql_user_pass" {
  sensitive   = true
  value       = module.safer-mysql-db.generated_user_password
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
}

output "reserved_range_name" {
  description = "The Global Address resource name"
  value       = module.private-service-access.google_compute_global_address_name
}

output "reserved_range_address" {
  description = "The Global Address resource name"
  value       = module.private-service-access.address
}


output "public_ip_address" {
  description = "The first public (PRIMARY) IPv4 address assigned for the master instance"
  value       = module.safer-mysql-db.public_ip_address
}

output "private_ip_address" {
  description = "The first private (PRIVATE) IPv4 address assigned for the master instance"
  value       = module.safer-mysql-db.private_ip_address
}

