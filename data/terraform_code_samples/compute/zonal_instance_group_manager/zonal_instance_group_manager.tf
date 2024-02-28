# [START compute_zonal_instance_group_manager_parent_tag]
resource "google_compute_instance_template" "default" {
  name         = "an-instance-template"
  machine_type = "e2-medium"

  disk {
    source_image = "debian-cloud/debian-11"
  }

  network_interface {
    network = "default"
  }
}

# [START compute_zonal_instance_group_manager_simple_tag]
resource "google_compute_instance_group_manager" "default" {

  name               = "example-group"
  base_instance_name = "test"
  target_size        = 3
  zone               = "us-central1-f"

  version {
    instance_template = google_compute_instance_template.default.id
    name              = "primary"
  }
}
# [END compute_zonal_instance_group_manager_simple_tag]
# [END compute_zonal_instance_group_manager_parent_tag]
