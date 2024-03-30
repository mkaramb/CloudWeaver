
output "name_servers" {
  description = "Zone name servers."
  value       = module.dns-private-zone.name_servers
}
