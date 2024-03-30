
output "connector_ids" {
  value       = module.serverless-connector.connector_ids
  description = "ID of the VPC serverless connector that was deployed."
}

output "project_id" {
  value       = var.project_id
  description = "The ID of the Google Cloud project being used"
}
