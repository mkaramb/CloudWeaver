
output "attachment" {
  value       = google_compute_interconnect_attachment.attachment
  description = "The created attachment"
}

output "customer_router_ip_address" {
  value       = google_compute_interconnect_attachment.attachment.customer_router_ip_address
  description = "IPv4 address + prefix length to be configured on the customer router subinterface for this interconnect attachment."
}
