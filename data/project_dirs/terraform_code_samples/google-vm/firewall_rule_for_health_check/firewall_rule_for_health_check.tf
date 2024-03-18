/**
 * Made to resemble:
 * gcloud compute firewall-rules create allow-health-check \
 *   --allow tcp:80 \
 *   --source-ranges 130.211.0.0/22,35.191.0.0/16 \
 *   --network default
 */


# [START compute_firewall_rule_for_health_check_tag]
resource "google_compute_firewall" "default" {
  name          = "allow-health-check"
  network       = "default"
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}
# [END compute_firewall_rule_for_health_check_tag]

