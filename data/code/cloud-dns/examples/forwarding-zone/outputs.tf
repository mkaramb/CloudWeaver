
output "name_servers" {
  description = "Zone name servers."
  value       = module.dns-forwarding-zone.name_servers
}
