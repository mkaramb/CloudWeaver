# [START cloudloadbalancing_regional_health_check]
resource "google_compute_region_health_check" "default" {
  name               = "tcp-health-check-region-west"
  timeout_sec        = 5
  check_interval_sec = 5
  tcp_health_check {
    port = "80"
  }
  region = "us-west1"
}
# [END cloudloadbalancing_regional_health_check]
