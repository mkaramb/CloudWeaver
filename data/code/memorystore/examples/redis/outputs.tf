
output "project_id" {
  value = var.project_id
}

output "output_id" {
  value = module.memstore.id
}

output "output_host" {
  value = module.memstore.host
}

output "output_region" {
  value = module.memstore.region
}

output "output_current_location_id" {
  value = module.memstore.current_location_id
}

output "output_auth_string" {
  value     = module.memstore.auth_string
  sensitive = true
}
