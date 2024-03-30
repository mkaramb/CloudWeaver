
output "project_id" {
  value = var.project_id
}

output "name" {
  description = "The name for Cloud SQL instance"
  value       = module.mysql.instance_name
}

output "authorized_network" {
  value = var.mysql_ha_external_ip_range
}

output "replicas" {
  value = module.mysql.replicas
}

output "instances" {
  value = module.mysql.instances
}
