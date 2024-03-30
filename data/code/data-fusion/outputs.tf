
output "instance" {
  description = "The created CDF instance"
  value       = module.instance.instance
}

output "tenant_project" {
  description = "The Google managed tenant project ID in which the instance will run its jobs"
  value       = module.instance.tenant_project
}
