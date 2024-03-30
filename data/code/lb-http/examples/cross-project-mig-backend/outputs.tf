
output "load-balancer-ip" {
  description = "The external IP assigned to the load balancer."
  value       = module.gce-lb-http.external_ip
}
