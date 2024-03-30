
output "names" {
  description = "Bucket names."
  value       = module.cloud_storage.names
}

output "names_list" {
  description = "List of bucket names."
  value       = module.cloud_storage.names_list
}

output "project_id" {
  description = "The ID of the project in which resources are provisioned."
  value       = var.project_id
}
