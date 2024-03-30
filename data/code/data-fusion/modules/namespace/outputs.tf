
output "name" {
  value       = cdap_namespace.namespace.name
  description = "The created CDAP namespace"
}

output "preferences" {
  value       = cdap_namespace_preferences.preferences
  description = "The preferences set in the CDAP namespace"
}
