/**
 * Made to resemble:
 * gcloud compute instance-groups managed create example-rmig \
 *   --template example-template \
 *   --size 30 \
 *   --zones us-east1-b,us-east1-c
 */

# [START compute_region_igm_spreading_parent_tag]
resource "google_compute_instance_template" "default" {
  name         = "example-template"
  machine_type = "e2-medium"
  disk {
    source_image = "debian-cloud/debian-11"
  }
  network_interface {
    network = "default"
  }
}

# [START compute_region_igm_spreading]
resource "google_compute_region_instance_group_manager" "default" {
  name                      = "example-rmig"
  region                    = "us-east1"
  distribution_policy_zones = ["us-east1-b", "us-east1-c"]
  target_size               = 30
  base_instance_name        = "instance"
  version {
    instance_template = google_compute_instance_template.default.id
  }
}
# [END compute_region_igm_spreading_parent_tag]
# [END compute_region_igm_spreading]
