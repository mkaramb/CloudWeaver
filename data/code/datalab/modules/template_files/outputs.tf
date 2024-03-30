
output "startup_script" {
  description = "Rendered startup script"
  value       = local.startup_script_content
}

output "cloud_config" {
  description = "Rendered cloud config from template"
  value       = data.template_file.cloud_config.rendered
}
