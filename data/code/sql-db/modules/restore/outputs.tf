
output "import_workflow_name" {
  value       = google_workflows_workflow.sql_import.name
  description = "The name for import workflow"
}

output "service_account" {
  value       = local.service_account
  description = "The service account email running the scheduler and workflow"
}

output "region" {
  description = "The region for running the scheduler and workflow"
  value       = var.region
}
