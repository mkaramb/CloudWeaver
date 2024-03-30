# [START networkmanagement_test_addresses]
resource "google_network_management_connectivity_test" "default" {
  name = "conn-test-addr"
  source {
    ip_address   = google_compute_address.source_addr.address
    project_id   = google_compute_address.source_addr.project
    network      = google_compute_network.default.id
    network_type = "GCP_NETWORK"
  }

  destination {
    ip_address = google_compute_address.dest_addr.address
    project_id = google_compute_address.dest_addr.project
    network    = google_compute_network.default.id
    port       = "80"
  }

  protocol = "UDP"
}

resource "google_compute_network" "default" {
  name                    = "connectivity-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "connectivity-vpc-subnet"
  ip_cidr_range = "10.0.0.0/8"
  region        = "us-central1"
  network       = google_compute_network.default.id
}

resource "google_compute_firewall" "default" {
  name    = "allow-incoming-all"
  network = google_compute_network.default.name

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "source_addr" {
  name         = "src-addr"
  subnetwork   = google_compute_subnetwork.default.id
  address_type = "INTERNAL"
  address      = "10.0.0.42"
  region       = "us-central1"
}

resource "google_compute_address" "dest_addr" {
  name         = "dest-addr"
  subnetwork   = google_compute_subnetwork.default.id
  address_type = "INTERNAL"
  address      = "10.0.0.43"
  region       = "us-central1"
}

resource "google_compute_instance" "source" {
  name         = "source-vm1"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.default.id
    }
  }

  network_interface {
    network    = google_compute_network.default.id
    subnetwork = google_compute_subnetwork.default.id
    network_ip = "10.0.0.42"
    access_config {
    }
  }
}

resource "google_compute_instance" "destination" {
  name         = "dest-vm1"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.default.id
    }
  }

  network_interface {
    network    = google_compute_network.default.id
    subnetwork = google_compute_subnetwork.default.id
    network_ip = "10.0.0.43"
    access_config {
    }
  }
}

data "google_compute_image" "default" {
  family  = "debian-11"
  project = "debian-cloud"
}
# [END networkmanagement_test_addresses]
