
output "project_id" {
  value = var.project_id
}

output "peering1" {
  description = "Peering1 module output."
  value       = module.peering-1
}

output "peering2" {
  description = "Peering2 module output."
  value       = module.peering-2
}
