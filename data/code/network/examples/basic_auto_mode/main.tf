
# [START vpc_auto_create]
resource "google_compute_network" "vpc_network" {
  project                 = var.project_id # Replace this with your project ID in quotes
  name                    = "my-auto-mode-network"
  auto_create_subnetworks = true
  mtu                     = 1460
}
# [END vpc_auto_create]
