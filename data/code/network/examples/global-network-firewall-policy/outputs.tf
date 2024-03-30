
output "project_id" {
  value       = module.firewal_policy.fw_policy[0].project
  description = "Firewall policy project ID"
}

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

output "firewall_policy_name" {
  value       = module.firewal_policy.fw_policy[0].name
  description = "Firewall policy name"
}

output "firewal_policy_no_rules" {
  value       = module.firewal_policy_no_rule.fw_policy[0]
  description = "Firewall policy created without any rules and association"
}

output "firewal_policy_no_rules_name" {
  value       = module.firewal_policy_no_rule.fw_policy[0].name
  description = "Name of Firewall policy created without any rules and association"
}
