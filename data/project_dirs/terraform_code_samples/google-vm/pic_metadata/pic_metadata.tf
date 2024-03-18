/**
 * Made to resemble:
 * gcloud compute instance-groups managed [create-instance|instance-configs update] example-cluster \
 *  --instance node-12 \
 *  --stateful-metadata mode=active,logging=elaborate
 */

# [START compute_stateful_instance_group_manager_metadata_parent_tag]
resource "google_compute_instance_template" "default" {
  machine_type = "e2-medium"

  disk {
    source_image = "debian-cloud/debian-11"
  }

  network_interface {
    network = "default"
  }
}

resource "google_compute_instance_group_manager" "default" {
  name               = "example-cluster"
  base_instance_name = "test"
  target_size        = 1
  zone               = "europe-west4-a"

  version {
    instance_template = google_compute_instance_template.default.id
    name              = "primary"
  }
}
# [START compute_stateful_instance_group_manager_metadata_pic]
resource "google_compute_per_instance_config" "default" {
  instance_group_manager = google_compute_instance_group_manager.default.name
  zone                   = google_compute_instance_group_manager.default.zone
  name                   = "node-12"
  preserved_state {
    metadata = {
      mode    = "active"
      logging = "elaborate"
    }
  }
}
# [END compute_stateful_instance_group_manager_metadata_pic]
# [END compute_stateful_instance_group_manager_metadata_parent_tag]
