
output "firewal_policy" {
  value       = module.firewal_policy.fw_policy[0]
  description = "Firewall policy created"
}

output "firewal_policy_rules" {
  value       = module.firewal_policy.rules
  description = "Firewall policy rules created"
}

output "firewal_policy_vpc_associations" {
  value       = module.firewal_policy.vpc_associations
  description = "Firewall policy vpc association"
}

output "project_id" {
  value       = module.firewal_policy.fw_policy[0].project
  description = "Firewall policy project ID"
}

output "firewall_policy_name" {
  value       = module.firewal_policy.fw_policy[0].name
  description = "Firewall policy name"
}

output "firewall_policy_region" {
  value       = "https://www.googleapis.com/compute/v1/projects/${module.firewal_policy.fw_policy[0].project}/regions/${module.firewal_policy.fw_policy[0].region}"
  description = "Firewall policy region"
}

output "firewal_policy_no_rules" {
  value       = module.firewal_policy_no_rule.fw_policy[0]
  description = "Firewall policy created without any rules and association"
}

output "firewal_policy_no_rules_name" {
  value       = module.firewal_policy_no_rule.fw_policy[0].name
  description = "Firewall policy name"
}

output "firewal_policy_no_rules_region" {
  value       = "https://www.googleapis.com/compute/v1/projects/${module.firewal_policy_no_rule.fw_policy[0].project}/regions/${module.firewal_policy_no_rule.fw_policy[0].region}"
  description = "Firewall policy region"
}
