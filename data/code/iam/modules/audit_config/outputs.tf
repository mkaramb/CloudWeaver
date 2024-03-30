
output "audit_log_config" {
  value       = var.audit_log_config
  description = "Map of log type and exempted members to be added to service"
  depends_on  = [google_project_iam_audit_config.project]
}
