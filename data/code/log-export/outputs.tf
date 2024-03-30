
output "filter" {
  description = "The filter to be applied when exporting logs."
  value       = var.filter
}

output "log_sink_resource_id" {
  description = "The resource ID of the log sink that was created."
  value       = local.log_sink_resource_id
}

output "log_sink_resource_name" {
  description = "The resource name of the log sink that was created."
  value       = local.log_sink_resource_name
}

output "parent_resource_id" {
  description = "The ID of the GCP resource in which you create the log sink."
  value       = local.log_sink_parent_id
}

output "writer_identity" {
  description = "The service account that logging uses to write log entries to the destination."
  value       = local.log_sink_writer_identity
}

