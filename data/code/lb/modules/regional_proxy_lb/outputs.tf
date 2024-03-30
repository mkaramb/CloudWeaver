
output "backend_services" {
  description = "The backend service resources."
  value       = google_compute_region_backend_service.default
  sensitive   = true // can contain sensitive iap_config
}

output "forwarding_rule" {
  description = "The forwarding rule of the load balancer."
  value       = google_compute_forwarding_rule.default
}


output "tcp_proxy" {
  description = "The TCP proxy used by this module."
  value       = google_compute_region_target_tcp_proxy.default.self_link
}
