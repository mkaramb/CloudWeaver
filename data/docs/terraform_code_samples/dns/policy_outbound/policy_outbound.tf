# [START dns_policy_outbound]
resource "google_dns_policy" "default" {
  name = "example-outbound-policy"

  alternative_name_server_config {
    target_name_servers {
      ipv4_address    = "172.16.1.10"
      forwarding_path = "private"
    }
    target_name_servers {
      ipv4_address = "172.16.1.20"
    }
  }

  networks {
    network_url = google_compute_network.default.id
  }
}

resource "google_compute_network" "default" {
  name                    = "network"
  auto_create_subnetworks = false
}
# [END dns_policy_outbound]
