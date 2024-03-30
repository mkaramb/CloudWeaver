
output "group1_region" {
  value = var.group1_region
}

output "project_id" {
  value = var.project_id
}

output "load-balancer-ip" {
  value = module.gce-lb-https.external_ip
}

output "asset-url" {
  value = "https://${module.gce-lb-https.external_ip}/assets/gcp-logo.svg"
}
