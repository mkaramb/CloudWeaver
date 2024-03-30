
output "resources" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  value       = var.resources
  depends_on = [
    google_access_context_manager_service_perimeter.bridge_service_perimeter,
    google_access_context_manager_service_perimeter_resource.service_perimeter_resource
  ]
}
