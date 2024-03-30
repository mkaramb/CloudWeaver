
output "name" {
  value       = module.pubsub_scheduled_example.name
  description = "The name of the job created"
}

output "project_id" {
  value       = var.project_id
  description = "The project ID"
}
