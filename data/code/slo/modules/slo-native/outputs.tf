
output "project_id" {
  description = "Project id"
  value       = local.project_id
}

output "name" {
  description = "The full resource name for the SLO"
  value       = google_monitoring_slo.slo.name
}
