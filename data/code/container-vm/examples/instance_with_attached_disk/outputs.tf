
output "vm_container_label" {
  description = "The instance label containing container configuration"
  value       = module.gce-container.vm_container_label
}

output "container" {
  description = "The container metadata provided to the module"
  value       = module.gce-container.container
}

output "volumes" {
  description = "The volume metadata provided to the module"
  value       = module.gce-container.volumes
}

output "http_address" {
  description = "The IP address on which the HTTP service is exposed"
  value       = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}

output "http_port" {
  description = "The port on which the HTTP service is exposed"
  value       = var.image_port
}

output "instance_name" {
  description = "The deployed instance name"
  value       = local.instance_name
}

output "ipv4" {
  description = "The public IP address of the deployed instance"
  value       = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}
