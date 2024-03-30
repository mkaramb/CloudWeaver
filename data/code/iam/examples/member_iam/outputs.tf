
output "roles" {
  value       = module.member_roles.roles
  description = "Project roles."
}

output "project_id" {
  value       = var.project_id
  description = "Project id."
}

output "service_account_address" {
  value       = google_service_account.member_iam_test.email
  description = "Member which was bound to projects."
}
