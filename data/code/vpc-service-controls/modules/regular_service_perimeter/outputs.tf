
output "shared_resources" {
  description = "A map of lists of resources to share in a Bridge perimeter module. Each list should contain all or a subset of the perimeters resources"
  value       = var.shared_resources
  depends_on = [
    google_access_context_manager_service_perimeter.regular_service_perimeter,
    google_access_context_manager_service_perimeter_resource.service_perimeter_resource
  ]
}

output "resources" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  value       = var.resources
  depends_on = [
    google_access_context_manager_service_perimeter.regular_service_perimeter,
    google_access_context_manager_service_perimeter_resource.service_perimeter_resource
  ]
}

output "perimeter_name" {
  description = "The perimeter's name."
  value       = var.perimeter_name
  depends_on = [
    google_access_context_manager_service_perimeter.regular_service_perimeter,
    google_access_context_manager_service_perimeter_resource.service_perimeter_resource
  ]
}
