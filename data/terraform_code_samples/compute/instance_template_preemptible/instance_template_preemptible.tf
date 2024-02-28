/**
 * Made to resemble
 * gcloud compute instance-templates create preemptible-template \
 * --preemptible
*/

# [START compute_template_preemptible]
resource "google_compute_instance_template" "default" {
  name         = "preemptible-template"
  machine_type = "n1-standard-1"
  disk {
    source_image = "debian-cloud/debian-11"
  }
  network_interface {
    network = "default"
  }
  scheduling {
    preemptible       = "true"
    automatic_restart = "false"
  }
}
# [END compute_template_preemptible]
