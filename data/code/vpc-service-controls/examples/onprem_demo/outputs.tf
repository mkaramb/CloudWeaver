
output "windows_onprem_public_ip" {
  description = "Public IP address for the 'onprem' Windows jumphost"
  value       = module.onprem_network.windows_onprem_public_ip
}

output "windows_cloud_private_ip" {
  description = "Private IP address for the 'cloud-based' Windows instance"
  value       = module.vpc_sc_network.windows_cloud_private_ip
}
