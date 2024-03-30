
output "mig_instance_group" {
  description = "The instance group url of the created MIG"
  value       = module.runner-mig-dind.mig_instance_group
}

output "mig_name" {
  description = "The name of the MIG"
  value       = module.runner-mig-dind.mig_name
}
