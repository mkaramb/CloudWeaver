# [START networkmanagement_test_instances]
resource "google_network_management_connectivity_test" "instance_test" {
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

resource "google_compute_instance" "source" {
  name         = "source-vm"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_9.id
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
}

resource "google_compute_instance" "destination" {
  name         = "dest-vm"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_9.id
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
}

data "google_compute_image" "debian_9" {
  family  = "debian-11"
  project = "debian-cloud"
}
# [END networkmanagement_test_instances]
