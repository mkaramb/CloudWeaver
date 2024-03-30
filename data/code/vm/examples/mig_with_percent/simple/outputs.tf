
output "self_link" {
  description = "Self-link of the managed instance group"
  value       = module.mig_with_percent.self_link
}

output "region" {
  description = "The GCP region to create and test resources in"
  value       = var.region
}

output "preemptible_self_link" {
  description = "Self-link of preemptible instance template"
  value       = module.preemptible_and_regular_instance_templates.preemptible_self_link
}

output "regular_self_link" {
  description = "Self-link of regular instance template"
  value       = module.preemptible_and_regular_instance_templates.regular_self_link
}
