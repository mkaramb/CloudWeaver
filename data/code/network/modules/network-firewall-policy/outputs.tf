
output "fw_policy" {
  value       = coalescelist(google_compute_network_firewall_policy.fw_policy, google_compute_region_network_firewall_policy.fw_policy)
  description = "Firewall policy created"
}

output "vpc_associations" {
  value       = merge(google_compute_network_firewall_policy_association.vpc_associations, google_compute_region_network_firewall_policy_association.vpc_associations)
  description = "VPC associations created"
}

output "rules" {
  value       = merge(google_compute_network_firewall_policy_rule.rules, google_compute_region_network_firewall_policy_rule.rules)
  description = "Firewall policy rules created"
}
