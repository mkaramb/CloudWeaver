
output "kubernetes_endpoint" {
  description = "The cluster endpoint"
  sensitive   = true
  value       = module.runner-gke.kubernetes_endpoint
}

output "client_token" {
  description = "The bearer token for auth"
  sensitive   = true
  value       = module.runner-gke.client_token
}

output "ca_certificate" {
  description = "The cluster ca certificate (base64 encoded)"
  value       = module.runner-gke.ca_certificate
}

output "service_account" {
  description = "The default service account used for running nodes."
  value       = module.runner-gke.service_account
}

output "cluster_name" {
  description = "Cluster name"
  value       = module.runner-gke.cluster_name
}

output "location" {
  description = "Cluster location"
  value       = module.runner-gke.location
}

