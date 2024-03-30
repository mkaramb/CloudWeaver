
output "kms_crypto_keys" {
  value       = distinct(module.helper.bindings_by_member[*].name)
  description = "KMS crypto keys which received bindings."
  depends_on  = [google_kms_crypto_key_iam_binding.kms_crypto_key_iam_authoritative, google_kms_crypto_key_iam_member.kms_crypto_key_iam_additive, ]
}

output "roles" {
  value       = distinct(module.helper.bindings_by_member[*].role)
  description = "Roles which were assigned to members."
}

output "members" {
  value       = distinct(module.helper.bindings_by_member[*].member)
  description = "Members which were bound to the KMS crypto keys."
}
