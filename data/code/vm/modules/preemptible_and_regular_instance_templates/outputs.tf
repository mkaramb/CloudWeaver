
output "preemptible_self_link" {
  description = "Self-link of preemptible instance template"
  value       = module.preemptible.self_link
}

output "preemptible_name" {
  description = "Name of preemptible instance template"
  value       = module.preemptible.name
}

output "regular_self_link" {
  description = "Self-link of regular instance template"
  value       = module.regular.self_link
}

output "regular_name" {
  description = "Name of regular instance template"
  value       = module.regular.name
}
