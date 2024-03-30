
output "self_link" {
  description = "Self-link of the managed instance group"
  value       = module.mig.self_link
}

output "region" {
  description = "The GCP region to create and test resources in"
  value       = var.region
}
