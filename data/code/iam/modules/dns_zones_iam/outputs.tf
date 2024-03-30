
output "managed_zones" {
  value       = distinct(module.helper.bindings_by_member[*].name)
  description = "DNS Managed Zones which received for bindings."
  depends_on  = [google_dns_managed_zone_iam_binding.dns_zone_iam_authoritative, google_dns_managed_zone_iam_member.dns_zone_iam_additive, ]
}

output "roles" {
  value       = distinct(module.helper.bindings_by_member[*].role)
  description = "Roles which were assigned to members."
}

output "members" {
  value       = distinct(module.helper.bindings_by_member[*].member)
  description = "Members which were bound to the Tag keys."
}
