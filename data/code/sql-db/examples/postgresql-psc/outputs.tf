
output "project_id" {
  value = var.project_id
}

output "name" {
  description = "The name for Cloud SQL instance"
  value       = module.pg.instance_name
}

output "dns_name" {
  value = module.pg.dns_name
}
