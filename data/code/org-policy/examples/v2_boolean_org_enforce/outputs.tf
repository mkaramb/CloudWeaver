
output "policy_root" {
  description = "Policy Root in the hierarchy for the given policy"
  value       = module.gcp_org_policy_v2.policy_root
}

output "policy_root_id" {
  description = "Project Root ID at which the policy is applied"
  value       = module.gcp_org_policy_v2.policy_root_id
}

output "constraint" {
  description = "Policy Constraint Identifier"
  value       = module.gcp_org_policy_v2.constraint
}

