
output "log_export_map" {
  description = "Outputs from the log export module"

  value = {
    filter             = module.log_export.filter
    parent_resource_id = module.log_export.parent_resource_id
    writer_identity    = module.log_export.writer_identity
  }
}

output "destination_map" {
  description = "Outputs from the destination module"

  value = {
    project         = module.destination.project
    destination_uri = module.destination.destination_uri
  }
}

