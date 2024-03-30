
output "name" {
  value       = module.scheduled_project_cleaner.name
  description = "The name of the job created"
}

output "project_id" {
  value       = var.project_id
  description = "The project ID"
}
