/**
 * Made to resemble:
 * gcloud compute instance-groups managed create example-database-group \
 *  --template example-database-template-v01 \
 *  --base-instance-name shard \
 *  --size 12 \
 *  --stateful-disk device-name=data-disk,auto-delete=on-permanent-instance-deletion
 */

# [START compute_stateful_instance_group_manager_disk_policy_parent_tag]
resource "google_compute_instance_template" "default" {
  name         = "example-database-template-v01"
  machine_type = "e2-medium"
  disk {
    device_name  = "data-disk"
    source_image = "debian-cloud/debian-11"
  }
  network_interface {
    network = "default"
  }
}

# [START compute_stateful_instance_group_manager_disk_policy]
resource "google_compute_instance_group_manager" "default" {
  name               = "example-database-group"
  base_instance_name = "shard"
  target_size        = 12
  zone               = "us-central1-f"
  version {
    instance_template = google_compute_instance_template.default.id
    name              = "primary"
  }
  stateful_disk {
    device_name = "data-disk"
    delete_rule = "ON_PERMANENT_INSTANCE_DELETION"
  }
}
# [END compute_stateful_instance_group_manager_disk_policy]
# [END compute_stateful_instance_group_manager_disk_policy_parent_tag]
