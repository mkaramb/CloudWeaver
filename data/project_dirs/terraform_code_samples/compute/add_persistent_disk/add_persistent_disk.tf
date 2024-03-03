# [START compute_add_persistent_disk_parent_tag]
resource "google_project_service" "compute_api" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

# [START compute_create_persistent_disk]
# Using pd-standard because it's the default for Compute Engine

resource "google_compute_disk" "default" {
  name = "disk-data"
  type = "pd-standard"
  zone = "us-west1-a"
  size = "5"
}
# [END compute_create_persistent_disk]

# [START compute_attach_persistent_disk]
resource "google_compute_instance" "test_node" {
  name         = "test-node"
  machine_type = "f1-micro"
  zone         = "us-west1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  attached_disk {
    source      = google_compute_disk.default.id
    device_name = google_compute_disk.default.name
  }

  network_interface {
    network = "default"
    access_config {
      # Ephemeral IP
    }
  }

  # Ignore changes for persistent disk attachments
  lifecycle {
    ignore_changes = [attached_disk]
  }


}
# [END compute_attach_persistent_disk]
# [END compute_add_persistent_disk_parent_tag]
