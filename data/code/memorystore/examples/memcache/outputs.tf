

output "project_id" {
  value = var.project_id
}

output "output_id" {
  value = module.memcache.id
}

output "output_region" {
  value = module.memcache.region
}

output "output_nodes" {
  value = module.memcache.nodes
}

output "output_discovery" {
  value = module.memcache.discovery
}
