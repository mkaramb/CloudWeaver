
output "network_name" {
  description = "The VPC created for the private Data Fusion instance"
  value       = module.vpc.network_name
}

output "data_fusion_vpc" {
  description = "The VPC created for the private Data Fusion instance"
  value       = module.vpc.network
}

output "dataproc_subnet" {
  description = "The subnetwork created for Dataproc clusters controlled by the private Data Fusion instance"
  value       = module.vpc.subnets["${var.region}/${var.dataproc_subnet}"]
}

output "data_fusion_ip_allocation" {
  description = "The IP CIDR range reserved for the private Data Fusion instance"
  value       = "${google_compute_global_address.data_fusion_private_ip_alloc.address}/${google_compute_global_address.data_fusion_private_ip_alloc.prefix_length}"
}

