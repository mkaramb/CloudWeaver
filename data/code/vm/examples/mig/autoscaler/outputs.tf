
output "instance_template_self_link" {
  description = "Self-link of instance template"
  value       = module.instance_template.self_link
}

output "mig_self_link" {
  description = "Self-link for managed instance group"
  value       = module.mig.self_link
}

output "region" {
  description = "The GCP region to create and test resources in"
  value       = var.region
}
