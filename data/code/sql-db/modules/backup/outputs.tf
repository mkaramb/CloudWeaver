
output "backup_workflow_name" {
  value       = var.enable_internal_backup ? google_workflows_workflow.sql_backup[0].name : null
  description = "The name for internal backup workflow"
}

output "export_workflow_name" {
  value       = var.enable_export_backup ? google_workflows_workflow.sql_export[0].name : null
  description = "The name for export workflow"
}

output "service_account" {
  value       = local.service_account
  description = "The service account email running the scheduler and workflow"
}

output "region" {
  description = "The region for running the scheduler and workflow"
  value       = var.region
}
