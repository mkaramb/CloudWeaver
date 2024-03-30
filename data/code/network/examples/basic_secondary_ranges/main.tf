
# [START vpc_secondary_range_create]
resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  project       = var.project_id # Replace this with your project ID in quotes
  name          = "test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = "test-vpc-network"
  secondary_ip_range {
    range_name    = "tf-test-secondary-range-update1"
    ip_cidr_range = "192.168.10.0/24"
  }
}
# [END vpc_secondary_range_create]
