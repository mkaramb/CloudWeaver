
output "policy_name" {
  description = "Name of the parent policy"
  value       = var.policy_name
}

output "protected_project_ids" {
  description = "Project ids of the projects INSIDE the regular service perimeter"
  value       = local.projects
}

output "function_service_account" {
  description = "Email of the watcher function's Service Account"
  value       = google_service_account.watcher.email
}

output "organization_id" {
  description = "Organization ID hosting the perimeter"
  value       = local.parent_id
}

output "project_id" {
  value       = var.project_id
  description = "The ID of the project hosting the watcher function."
}

output "folder_id" {
  value       = var.folder_id
  description = "The ID of the watched folder."
}
