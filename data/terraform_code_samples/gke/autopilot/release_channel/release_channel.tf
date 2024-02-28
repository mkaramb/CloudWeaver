# [START gke_autopilot_release_channel]
resource "google_container_cluster" "default" {
  name     = "gke-autopilot-release-channel"
  location = "us-central1"

  enable_autopilot = true

  release_channel {
    channel = "REGULAR"
  }

  # Set `deletion_protection` to `true` will ensure that one cannot
  # accidentally delete this instance by use of Terraform.
  deletion_protection = false
}
# [END gke_autopilot_release_channel]
