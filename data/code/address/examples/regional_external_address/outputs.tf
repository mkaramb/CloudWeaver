
output "names" {
  description = "List of address resource names"
  value       = module.address.names
}

output "addresses" {
  description = "List of address values managed by this module"
  value       = module.address.addresses
}


