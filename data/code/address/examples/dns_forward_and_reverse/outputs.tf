
output "addresses" {
  description = "List of address values managed by this module (e.g. [\"1.2.3.4\"])"
  value       = module.address.addresses
}

output "names" {
  description = "List of address resource names managed by this module (e.g. [\"gusw1-dev-fooapp-fe-0001-a-0001-ip\"])"
  value       = module.address.names
}

output "dns_fqdns" {
  description = "List of DNS fully qualified domain names registered in Cloud DNS.  (e.g. [\"gusw1-dev-fooapp-fe-0001-a-001.example.com\", \"gusw1-dev-fooapp-fe-0001-a-0002.example.com\"])"
  value       = module.address.dns_fqdns
}

output "reverse_dns_fqdns" {
  description = "List of reverse DNS PTR records registered in Cloud DNS."
  value       = module.address.reverse_dns_fqdns
}

output "forward_zone" {
  description = "The GCP name of the forward lookup DNS zone being used"
  value       = var.dns_managed_zone
}

output "reverse_zone" {
  description = "The GCP name of the reverse lookup DNS zone being used"
  value       = var.dns_reverse_zone
}

