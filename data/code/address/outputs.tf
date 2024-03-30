
output "addresses" {
  description = "List of address values managed by this module (e.g. [\"1.2.3.4\"])"
  value       = local.ip_addresses
}

output "names" {
  description = "List of address resource names managed by this module (e.g. [\"gusw1-dev-fooapp-fe-0001-a-0001-ip\"])"
  value       = local.ip_names
}

output "self_links" {
  description = "List of URIs of the created address resources"
  value       = local.self_links
}

output "dns_fqdns" {
  description = "List of DNS fully qualified domain names registered in Cloud DNS.  (e.g. [\"gusw1-dev-fooapp-fe-0001-a-001.example.com\", \"gusw1-dev-fooapp-fe-0001-a-0002.example.com\"])"
  value       = local.dns_fqdns
}

output "reverse_dns_fqdns" {
  description = "List of reverse DNS PTR records registered in Cloud DNS.  (e.g. [\"1.2.11.10.in-addr.arpa\", \"2.2.11.10.in-addr.arpa\"])"
  value       = local.dns_ptr_fqdns
}

