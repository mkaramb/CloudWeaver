
output "kms_key_rings" {
  value       = distinct(module.helper.bindings_by_member[*].name)
  description = "KMS key rings which received bindings."
  depends_on  = [google_kms_key_ring_iam_binding.kms_key_ring_iam_authoritative, google_kms_key_ring_iam_member.kms_key_ring_iam_additive, ]
}

output "roles" {
  value       = distinct(module.helper.bindings_by_member[*].role)
  description = "Roles which were assigned to members."
}

output "members" {
  value       = distinct(module.helper.bindings_by_member[*].member)
  description = "Members which were bound to the KMS key rings."
}
