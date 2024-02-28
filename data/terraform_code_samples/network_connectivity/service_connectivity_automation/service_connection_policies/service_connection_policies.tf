# [START networkconnectivitycenter_create_service_connection_policy]
# Create a VPC network
resource "google_compute_network" "default" {
  name                    = "consumer-network"
  auto_create_subnetworks = false
}

# Create a subnetwork
resource "google_compute_subnetwork" "default" {
  name          = "consumer-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.default.id
}

# Create a service connection policy
resource "google_network_connectivity_service_connection_policy" "default" {
  name          = "service-connection-policy"
  location      = "us-central1"
  service_class = "gcp-memorystore-redis"
  network       = google_compute_network.default.id
  psc_config {
    subnetworks = [google_compute_subnetwork.default.id]
    limit       = 2
  }
}
# [END networkconnectivitycenter_create_service_connection_policy]

