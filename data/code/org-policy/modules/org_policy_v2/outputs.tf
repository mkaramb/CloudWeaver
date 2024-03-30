
output "policy_root" {
  description = "Policy Root in the hierarchy for the given policy"
  value       = var.policy_root
}

output "policy_root_id" {
  description = "Project Root ID at which the policy is applied"
  value       = var.policy_root_id
}

output "constraint" {
  description = "Policy Constraint Identifier without constraints/ prefix"
  value       = var.constraint
}
