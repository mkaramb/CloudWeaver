# [START compute_instances_create_with_local_ssd]

# Create a VM with a local SSD for temporary storage use cases

resource "google_compute_instance" "default" {
  name         = "my-vm-instance-with-scratch"
  machine_type = "n2-standard-8"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  # Local SSD interface type; NVME for image with optimized NVMe drivers or SCSI
  # Local SSD are 375 GiB in size
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = "default"
    access_config {}
  }
}
# [END compute_instances_create_with_local_ssd]
