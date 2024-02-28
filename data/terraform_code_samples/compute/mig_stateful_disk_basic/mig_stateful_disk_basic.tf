/**
 * Made to resemble:
 * gcloud compute instance-groups managed create igm-stateful-disk-basic \
 *  --template example-template \
 *  --size 1 \
 *  --stateful-disk device-name=example-disk,auto-delete=NEVER
 */

# [START compute_zonal_mig_stateful_disk_basic_parent_tag]
resource "google_compute_instance_template" "default" {
  name         = "example-template"
  machine_type = "e2-medium"
  disk {
    device_name  = "example-disk"
    source_image = "debian-cloud/debian-11"
  }
  network_interface {
    network = "default"
  }
}

# [START compute_zonal_mig_stateful_disk_basic]
resource "google_compute_instance_group_manager" "default" {
  name               = "igm-stateful-disk-basic"
  zone               = "us-central1-f"
  base_instance_name = "instance"
  target_size        = 1

  version {
    instance_template = google_compute_instance_template.default.id
  }

  stateful_disk {
    device_name = "example-disk"
    delete_rule = "NEVER"
  }

}
# [END compute_zonal_mig_stateful_disk_basic]
# [END compute_zonal_mig_stateful_disk_basic_parent_tag]
