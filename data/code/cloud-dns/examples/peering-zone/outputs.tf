
output "name_servers" {
  description = "Zone name servers."
  value       = module.dns-peering-zone.name_servers
}
