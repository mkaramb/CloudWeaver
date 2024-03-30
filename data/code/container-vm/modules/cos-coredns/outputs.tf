
output "instances" {
  description = "Instance name => address map."
  value       = zipmap(google_compute_instance.default[*].name, google_compute_address.addresses[*].address)
}

output "names" {
  description = "List of instance names."
  value       = [google_compute_instance.default[*].name]
}

output "internal_addresses" {
  description = "List of instance internal addresses."
  value       = [google_compute_instance.default[*].network_interface[0].network_ip]
}
