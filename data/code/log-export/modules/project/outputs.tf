
output "project" {
  description = "The ID of the project to which logs will be routed."
  value       = var.project_id
}

output "destination_uri" {
  description = "The destination URI for project."
  value       = local.destination_uri
}

