
output "cluster_name" {
  value = google_container_cluster.default.name
}

output "network_name" {
  value = var.network_name
}

output "port_name" {
  value = "http"
}

output "port_number" {
  value = var.node_port
}

output "instance_group" {
  value = google_container_cluster.default.node_pool[0].instance_group_urls[0]
}

output "node_tag" {
  value = var.node_tag
}
