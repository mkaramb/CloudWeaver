/**
 * Made to resemble:
 * gcloud compute instance-groups managed create example-rmig \
 *   --template example-template \
 *   --size 30 \
 *   --zones us-east1-b,us-east1-c \
 *   --target-distribution-shape balanced \
 *   --instance-redistribution-type NONE
 */

# [START compute_region_igm_shape_parent_tag]
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

# [START compute_region_igm_shape]
resource "google_compute_region_instance_group_manager" "default" {
  name                             = "example-rmig"
  region                           = "us-east1"
  distribution_policy_zones        = ["us-east1-b", "us-east1-c"]
  distribution_policy_target_shape = "BALANCED"
  update_policy {
    type                         = "PROACTIVE"
    minimal_action               = "REFRESH"
    instance_redistribution_type = "NONE"
    max_unavailable_fixed        = 3
  }
  target_size        = 30
  base_instance_name = "instance"
  version {
    instance_template = google_compute_instance_template.default.id
  }
}
# [END compute_region_igm_shape]
# [END compute_region_igm_shape_parent_tag]
