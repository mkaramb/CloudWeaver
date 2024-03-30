
output "instance_template_self_link" {
  description = "Self-link of instance template"
  value       = module.instance_template.self_link
}

output "umig_self_links" {
  description = "List of self-links for unmanaged instance groups"
  value       = module.umig.self_links
}

