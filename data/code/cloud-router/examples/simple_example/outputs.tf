
output "router_name" {
  value       = module.cloud_router.router.name
  description = "The name of the created router"
}

output "router_region" {
  value       = module.cloud_router.router.region
  description = "The region of the created router"
}

output "project_id" {
  value       = module.cloud_router.router.project
  description = "Project ID of the router"
}

output "router" {
  value       = module.cloud_router.router.project
  description = "Project ID of the router"
}
