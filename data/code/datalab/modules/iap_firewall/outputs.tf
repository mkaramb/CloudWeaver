
output "firewall_name" {
  description = "The name of the firewall rule"
  value       = var.create_rule ? google_compute_firewall.iap[0].name : ""
}
