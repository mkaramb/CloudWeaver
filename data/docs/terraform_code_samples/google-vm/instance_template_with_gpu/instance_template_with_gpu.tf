/**
 * Made to resemble
 * gcloud compute instance-templates create gpu-template \
 * --machine-type n1-standard-2 \
 * --accelerator type=nvidia-tesla-t4,count=1 \
 * --image-family debian-11 \
 * --image-project debian-cloud \
 * --maintenance-policy TERMINATE
*/

# [START compute_template_gpu]
resource "google_compute_instance_template" "default" {
  name         = "gpu-template"
  machine_type = "n1-standard-2"

  disk {
    source_image = "debian-cloud/debian-11"
  }

  network_interface {
    network = "default"
  }

  guest_accelerator {
    type  = "nvidia-tesla-t4"
    count = 1
  }

  scheduling {
    on_host_maintenance = "TERMINATE"
  }
}
# [END compute_template_gpu]
