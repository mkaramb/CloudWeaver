
output "name_servers" {
  description = "Zone name servers."
  value       = module.dns-public-zone.name_servers
}
