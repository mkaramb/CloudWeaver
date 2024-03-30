
output "subnets" {
  value       = distinct(module.helper.bindings_by_member[*].name)
  description = "Subnetworks which received bindings."
  depends_on  = [google_compute_subnetwork_iam_binding.subnet_iam_authoritative, google_compute_subnetwork_iam_member.subnet_iam_additive, ]
}

output "roles" {
  value       = distinct(module.helper.bindings_by_member[*].role)
  description = "Roles which were assigned to members."
}

output "members" {
  value       = distinct(module.helper.bindings_by_member[*].member)
  description = "Members which were bound to the Subnetwork."
}
