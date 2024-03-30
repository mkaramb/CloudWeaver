
output "connector_ids" {
  value = toset([
  for k in google_vpc_access_connector.connector_beta : k.id])
  description = "VPC serverless connector ID."
}
