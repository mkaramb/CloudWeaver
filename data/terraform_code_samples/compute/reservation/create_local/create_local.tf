# [START compute_reservation_create_local_reservation]

resource "google_compute_reservation" "default" {
  name = "gce-reservation-local"
  zone = "us-central1-a"

  /**
   * To specify a single-project reservation, omit the share_settings block
   * (default) or set the share_type field to LOCAL.
   */
  share_settings {
    share_type = "LOCAL"
  }

  specific_reservation {
    count = 1
    instance_properties {
      machine_type = "n2-standard-2"
    }
  }

  /**
   * To let VMs with affinity for any reservation consume this reservation, omit
   * the specific_reservation_required field (default) or set it to false.
   */
  specific_reservation_required = false
}

# [END compute_reservation_create_local_reservation]
