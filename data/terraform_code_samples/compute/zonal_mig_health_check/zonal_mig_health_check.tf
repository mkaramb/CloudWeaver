/**
 * Made to resemble:
 * gcloud compute instance-groups managed create igm-with-hc \
 *   --size 3 \
 *   --template an-instance-template \
 *   --health-check example-check \
 *   --initial-delay 30s \
 *   --zone us-central1-f
 */

# [START compute_zonal_instance_group_manager_hc_parent_tag]
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

resource "google_compute_http_health_check" "default" {
  name                = "example-check"
  timeout_sec         = 10
  check_interval_sec  = 30
  healthy_threshold   = 1
  unhealthy_threshold = 3
  port                = "80"
}

resource "google_compute_firewall" "default" {
  name          = "allow-health-check"
  network       = "default"
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}

# [START compute_zonal_instance_group_manager_hc_igm_tag]
resource "google_compute_instance_group_manager" "default" {
  name               = "igm-with-hc"
  base_instance_name = "test"
  target_size        = 3
  zone               = "us-central1-f"
  version {
    instance_template = google_compute_instance_template.default.id
    name              = "primary"
  }
  auto_healing_policies {
    health_check      = google_compute_http_health_check.default.id
    initial_delay_sec = 30
  }
}
# [END compute_zonal_instance_group_manager_hc_igm_tag]
# [END compute_zonal_instance_group_manager_hc_parent_tag]
