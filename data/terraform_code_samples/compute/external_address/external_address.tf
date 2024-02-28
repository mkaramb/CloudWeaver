# [START compute_external_address_parent_tag]
# [START compute_regional_external_vm_address]
resource "google_compute_address" "default" {
  name   = "my-test-static-ip-address"
  region = "us-central1"
}
# [END compute_regional_external_vm_address]

# [START compute_regional_external_vm_address_assign]
resource "google_compute_instance" "default" {
  name         = "dns-proxy-nfs"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-1404-trusty-v20160627"
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.default.address
    }
  }
}
# [END compute_regional_external_vm_address_assign]
# [END compute_external_address_parent_tag]
