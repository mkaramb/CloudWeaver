
/******************************************
  Firewall rule to allow tunnel-through-iap
 *****************************************/
resource "google_compute_firewall" "iap" {
  count          = var.create_rule ? 1 : 0
  provider       = google-beta
  name           = "${var.network_name}-allow-iap"
  project        = var.project_id
  network        = var.network_name
  description    = var.firewall_description
  direction      = "INGRESS"
  disabled       = false
  priority       = "65534"
  enable_logging = true
  source_ranges  = ["35.235.240.0/20"]

  allow {
    protocol = "tcp"
    ports    = var.ports
  }

  target_tags = var.target_tags
}
