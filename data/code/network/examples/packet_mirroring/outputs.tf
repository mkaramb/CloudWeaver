

output "packet_mirror" {
  value       = google_compute_packet_mirroring.default.name
  description = "The name of the packet mirroring policy"
}

output "collector_ilb" {
  value       = google_compute_packet_mirroring.default.collector_ilb[0].url
  description = "The internal load balancer"
}

output "instance" {
  value       = google_compute_packet_mirroring.default.mirrored_resources[0].instances[0].url
  description = "The VM instance"
}
