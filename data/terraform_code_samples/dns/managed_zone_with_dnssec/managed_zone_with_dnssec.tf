# Google Cloud Documentation: https://cloud.google.com/dns/docs/dnssec-config#creating
# [START dns_managed_zone_with_dnssec]
resource "google_dns_managed_zone" "example" {
  name        = "example-zone-name"
  dns_name    = "example.com."
  description = "Example Signed Zone"
  dnssec_config {
    state = "on"
  }
}
# [END dns_managed_zone_with_dnssec]
