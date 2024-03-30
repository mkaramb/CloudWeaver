# [START dns_policy_inbound]
resource "google_dns_policy" "default" {
  name                      = "example-inbound-policy"
  enable_inbound_forwarding = true

  networks {
    network_url = google_compute_network.default.id
  }
}

resource "google_compute_network" "default" {
  name                    = "network"
  auto_create_subnetworks = false
}
# [END dns_policy_inbound]
