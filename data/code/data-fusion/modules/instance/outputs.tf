
output "instance" {
  value       = google_data_fusion_instance.instance
  description = "The created CDF instance"
}

output "tenant_project" {
  description = "The Google managed tenant project ID in which the instance will run its jobs"
  value       = google_data_fusion_instance.instance.tenant_project_id
}

output "service_account" {
  value       = google_data_fusion_instance.instance.service_account
  description = "The Google managed Data Fusion Service account"
}
