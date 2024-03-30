
output "cloud_run_services" {
  value       = distinct(module.helper.bindings_by_member[*].name)
  description = "Cloud Run services which received for bindings."
  depends_on  = [google_cloud_run_service_iam_binding.cloud_run_iam_authoritative, google_cloud_run_service_iam_member.cloud_run_iam_additive]
}

output "roles" {
  value       = distinct(module.helper.bindings_by_member[*].role)
  description = "Roles which were assigned to members."
}

output "members" {
  value       = distinct(module.helper.bindings_by_member[*].member)
  description = "Members which were bound to the Cloud Run services."
}
