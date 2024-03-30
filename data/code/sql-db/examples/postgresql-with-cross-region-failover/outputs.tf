
output "project_id" {
  value = var.project_id
}

// Primary instance with read replicas.

output "instance1_name" {
  description = "The name for Cloud SQL instance"
  value       = module.pg1.instance_name
}

output "instance1_replicas" {
  value     = module.pg1.replicas
  sensitive = true
}

output "instance1_instances" {
  value     = module.pg1.instances
  sensitive = true
}

output "kms_key_name1" {
  value     = module.pg1.primary.encryption_key_name
  sensitive = true
}

// Failover Replica instance with its own read replicas

output "instance2_name" {
  description = "The name for Cloud SQL instance"
  value       = module.pg2.instance_name
}

output "instance2_replicas" {
  value     = module.pg2.replicas
  sensitive = true
}

output "instance2_instances" {
  value     = module.pg2.instances
  sensitive = true
}

output "kms_key_name2" {
  value     = module.pg2.primary.encryption_key_name
  sensitive = true
}

output "master_instance_name" {
  value     = module.pg2.primary.master_instance_name
  sensitive = true
}
