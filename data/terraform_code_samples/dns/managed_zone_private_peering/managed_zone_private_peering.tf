# [START dns_managed_zone_private_peering]
resource "random_id" "zone_suffix" {
  byte_length = 8
}

resource "google_dns_managed_zone" "peering_zone" {
  name        = "peering-zone-${random_id.zone_suffix.hex}"
  dns_name    = "peering.example.com."
  description = "Example private DNS peering zone"

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.network_source.id
    }
  }

  peering_config {
    target_network {
      network_url = google_compute_network.network_target.id
    }
  }
}

resource "google_compute_network" "network_source" {
  name                    = "network-source"
  auto_create_subnetworks = false
}

resource "google_compute_network" "network_target" {
  name                    = "network-target"
  auto_create_subnetworks = false
}
# [END dns_managed_zone_private_peering]
