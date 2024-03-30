
output "project_id" {
  value       = var.project_id
  description = "The ID of the project to which resources are applied."
}

output "region" {
  value       = var.region
  description = "The region in which resources are applied."
}

output "test_project_id" {
  value       = google_project.test.project_id
  description = "The ID of the project to test."
}
