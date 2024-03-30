
output "router" {
  value       = google_compute_router.router
  description = "Created Router"
}

output "nat" {
  value       = google_compute_router_nat.nats
  description = "Created NATs"
}
