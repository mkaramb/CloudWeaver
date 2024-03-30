
module "iap_bastion_group" {
  source  = "terraform-google-modules/bastion-host/google//modules/bastion-group"
  version = "~> 6.0"

  project     = var.project_id
  region      = "us-west1"
  zone        = "us-west1-a"
  network     = google_compute_network.network.self_link
  subnet      = google_compute_subnetwork.subnet.self_link
  members     = var.members
  target_size = 2
}

resource "google_compute_network" "network" {
  project                 = var.project_id
  name                    = "test-network-group"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  project                  = var.project_id
  name                     = "test-subnet-group"
  region                   = "us-west1"
  ip_cidr_range            = "10.128.0.0/20"
  network                  = google_compute_network.network.self_link
  private_ip_google_access = true
}

resource "google_compute_firewall" "allow_access_from_bastion" {
  project = var.project_id
  name    = "allow-bastion-group-ssh"
  network = google_compute_network.network.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Allow SSH only from IAP Bastion
  source_service_accounts = [module.iap_bastion_group.service_account]
}
