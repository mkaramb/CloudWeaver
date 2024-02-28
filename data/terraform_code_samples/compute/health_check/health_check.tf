/**
 * Made to resemble:
 * gcloud compute health-checks create http example-check --port 80 \
 *  --check-interval 30s \
 *  --healthy-threshold 1 \
 *  --timeout 10s \
 *  --unhealthy-threshold 3 \
 *  --global
 */

# [START compute_health_check_tag]
resource "google_compute_http_health_check" "default" {
  name                = "example-check"
  timeout_sec         = 10
  check_interval_sec  = 30
  healthy_threshold   = 1
  unhealthy_threshold = 3
  port                = "80"
}
# [END compute_health_check_tag]
