
output "policy_id" {
  description = "Resource name of the AccessPolicy."
  value       = module.access_context_manager_policy.policy_id
}

output "policy_name" {
  description = "Name of the parent policy"
  value       = var.policy_name
}


output "protected_project_id" {
  description = "Project id of the project INSIDE the regular service perimeter"
  value       = var.protected_project_ids["id"]
}
