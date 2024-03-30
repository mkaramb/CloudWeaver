
output "pool_name" {
  description = "Pool name"
  value       = module.oidc.pool_name
}

output "provider_name" {
  description = "Provider name"
  value       = module.oidc.provider_name
}

output "sa_email" {
  description = "Example SA email"
  value       = google_service_account.sa.email
}
