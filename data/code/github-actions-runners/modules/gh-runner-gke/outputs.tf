
output "kubernetes_endpoint" {
  description = "The cluster endpoint"
  sensitive   = true
  value       = module.runner-cluster.endpoint
}

output "client_token" {
  description = "The bearer token for auth"
  sensitive   = true
  value       = base64encode(data.google_client_config.default.access_token)
}

output "ca_certificate" {
  description = "The cluster ca certificate (base64 encoded)"
  value       = module.runner-cluster.ca_certificate
}

output "service_account" {
  description = "The default service account used for running nodes."
  value       = module.runner-cluster.service_account
}

output "cluster_name" {
  description = "Cluster name"
  value       = module.runner-cluster.name
}

output "network_name" {
  description = "Name of VPC"
  value       = local.network_name
}

output "subnet_name" {
  description = "Name of VPC"
  value       = local.subnet_name
}

output "location" {
  description = "Cluster location"
  value       = module.runner-cluster.location
}
