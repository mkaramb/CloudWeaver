/**
 * Made to resemble
 * gcloud compute instance-groups managed create my-igm \
 *   --template my-template \
 *   --size 7 \
 *   --list-managed-instances-results=PAGINATED
 */

# [START compute_zonal_instance_group_manager_paginated_parent_tag]
resource "google_compute_instance_template" "default" {
  name         = "my-template"
  machine_type = "e2-medium"
  disk {
    source_image = "debian-cloud/debian-11"
  }
  network_interface {
    network = "default"
  }
}

# [START compute_zonal_instance_group_manager_paginated_tag]
resource "google_compute_instance_group_manager" "default" {
  name                           = "my-igm"
  base_instance_name             = "test"
  target_size                    = 7
  zone                           = "us-central1-f"
  list_managed_instances_results = "PAGINATED"
  version {
    instance_template = google_compute_instance_template.default.id
    name              = "primary"
  }
}
# [END compute_zonal_instance_group_manager_paginated_tag]
# [END compute_zonal_instance_group_manager_paginated_parent_tag]
