
output "external_ip" {
  description = "The external IP assigned to the load balancer."
  value       = module.gce-lb-http.external_ip
}

output "service_project" {
  description = "The service project the load balancer is in."
  value       = var.service_project
}
