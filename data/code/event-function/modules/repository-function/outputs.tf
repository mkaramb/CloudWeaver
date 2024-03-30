
output "name" {
  description = "The name of the function."
  value       = google_cloudfunctions_function.main.name
}

output "https_trigger_url" {
  description = "URL which triggers function execution."
  value       = var.trigger_http != null ? google_cloudfunctions_function.main.https_trigger_url : ""
}
