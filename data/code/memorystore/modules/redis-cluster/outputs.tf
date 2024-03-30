
output "id" {
  description = "The redis cluster instance ID"
  value       = google_redis_cluster.redis_cluster.id
}

output "discovery_endpoints" {
  description = "Endpoints created on each given network, for Redis clients to connect to the cluster. Currently only one endpoint is supported"
  value       = google_redis_cluster.redis_cluster.discovery_endpoints
}

output "psc_connections" {
  description = "PSC connections for discovery of the cluster topology and accessing the cluster"
  value       = google_redis_cluster.redis_cluster.psc_connections
}

output "redis_cluster" {
  description = "The redis cluster created"
  value       = google_redis_cluster.redis_cluster
}
