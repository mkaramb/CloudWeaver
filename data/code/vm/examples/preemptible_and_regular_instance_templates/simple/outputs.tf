
output "regular_self_link" {
  description = "Self-link to the regular instance template"
  value       = module.preemptible_and_regular_instance_templates.regular_self_link
}

output "regular_name" {
  description = "Name of the regular instance templates"
  value       = module.preemptible_and_regular_instance_templates.regular_name
}

output "preemptible_self_link" {
  description = "Self-link to the preemptible instance template"
  value       = module.preemptible_and_regular_instance_templates.preemptible_self_link
}

output "preemptible_name" {
  description = "Name of the preemptible instance templates"
  value       = module.preemptible_and_regular_instance_templates.preemptible_name
}
