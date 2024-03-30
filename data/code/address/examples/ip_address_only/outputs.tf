
output "addresses" {
  description = "List of address values managed by this module (e.g. [\"1.2.3.4\"])"
  value       = module.address.addresses
}

output "names" {
  description = "List of address resource names managed by this module (e.g. [\"gusw1-dev-fooapp-fe-0001-a-0001-ip\"])"
  value       = module.address.names
}

