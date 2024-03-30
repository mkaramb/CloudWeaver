
output "instances_self_links" {
  description = "List of self-links for compute instances"
  value       = module.compute_instance.instances_self_links
}

output "disk_snapshots" {
  description = "List of disks snapshots and the snapshot policy"
  value       = module.disk_snapshots
}

