
# [START compute_vm_with_tags_create]
resource "google_compute_instance" "default" {
  project      = var.project_id # Replace this with your project ID in quotes
  zone         = "southamerica-east1-b"
  name         = "backend-instance"
  machine_type = "e2-medium"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    network = "default"
  }
  tags = ["health-check", "ssh"]
}
# [END compute_vm_with_tags_create]
