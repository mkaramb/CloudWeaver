
output "id" {
  description = "The memorystore instance ID."
  value       = google_memcache_instance.self.id
}

output "region" {
  description = "The region the instance lives in."
  value       = google_memcache_instance.self.region
}

output "nodes" {
  description = "Data about the memcache nodes"
  value       = google_memcache_instance.self.memcache_nodes
}

output "discovery" {
  description = "The memorystore discovery endpoint."
  value       = google_memcache_instance.self.discovery_endpoint
}
