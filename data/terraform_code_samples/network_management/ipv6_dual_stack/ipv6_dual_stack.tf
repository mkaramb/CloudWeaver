# [START networkmanagement_test_ipv6_instances]
resource "google_network_management_connectivity_test" "conn_test_instances" {
  name = "conn-test-instances"
  source {
    instance = google_compute_instance.source.id
  }

  destination {
    instance = google_compute_instance.destination.id
    port     = "80"
  }

  protocol = "TCP"
}

data "google_compute_image" "default" {
  family  = "debian-11"
  project = "debian-cloud"
}

resource "google_compute_instance" "source" {
  name         = "source-vm"
  machine_type = "e2-medium"
  zone         = "us-west2-a"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.default.id
    }
  }

  network_interface {
    network    = google_compute_network.default.id
    subnetwork = google_compute_subnetwork.default.id
    network_ip = "10.0.0.142"
    stack_type = "IPV4_IPV6"
    access_config {
    }
  }
}

resource "google_compute_instance" "destination" {
  name         = "destination-vm"
  machine_type = "e2-medium"
  zone         = "us-west2-a"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.default.id
    }
  }

  network_interface {
    network    = google_compute_network.default.id
    subnetwork = google_compute_subnetwork.default.id
    network_ip = "10.0.0.143"
    stack_type = "IPV4_IPV6"
    access_config {
    }
  }
}

resource "google_compute_subnetwork" "default" {
  name = "example-subnetwork"

  ip_cidr_range = "10.0.0.0/22"
  region        = "us-west2"

  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "INTERNAL"

  network = google_compute_network.default.id
}

resource "google_compute_network" "default" {
  name                     = "example-network"
  auto_create_subnetworks  = false
  enable_ula_internal_ipv6 = true
}

resource "google_compute_firewall" "ipv6_allow_all" {
  name    = "example-allow-incoming-ipv6"
  network = google_compute_network.default.name

  allow {
    protocol = "all"
  }
  source_ranges = ["::/0"]
}

resource "google_compute_firewall" "ipv4_allow_all" {
  name    = "example-allow-incoming-ipv4"
  network = google_compute_network.default.name

  allow {
    protocol = "all"
  }
  source_ranges = ["10.0.0.0/22"]
}
# [END networkmanagement_test_ipv6_instances]
