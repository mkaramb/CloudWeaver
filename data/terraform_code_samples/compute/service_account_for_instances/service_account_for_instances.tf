# [START compute_service_account_for_instances_parent_tag]
# [START iam_service_account_for_vm]
resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}
# [END iam_service_account_for_vm]

# [START compute_instance_run_as_service_account]
resource "google_compute_instance" "default" {
  name         = "my-test-vm"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  service_account {
    # Google recommends custom service accounts with `cloud-platform` scope with
    # specific permissions granted via IAM Roles.
    # This approach lets you avoid embedding secret keys or user credentials
    # in your instance, image, or app code
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}
# [END compute_instance_run_as_service_account]
# [END compute_service_account_for_instances_parent_tag]
