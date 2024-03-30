
output "addresses" {
  description = "IP address"
  value       = google_compute_global_address.default.address
}
