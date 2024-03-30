
output "log_bucket_project" {
  description = "The project where the log bucket is created."
  value       = module.destination.project
}

output "log_bucket_name" {
  description = "The name for the log bucket."
  value       = module.destination.resource_name
}

output "log_sink_folder_id" {
  description = "The folder id where the log sink is created."
  value       = module.log_export.parent_resource_id
}

output "log_sink_destination_uri" {
  description = "A fully qualified URI for the log sink."
  value       = module.destination.destination_uri
}

output "log_sink_writer_identity" {
  description = "Writer identity for the log sink that writes to the log bucket."
  value       = module.log_export.writer_identity
}
