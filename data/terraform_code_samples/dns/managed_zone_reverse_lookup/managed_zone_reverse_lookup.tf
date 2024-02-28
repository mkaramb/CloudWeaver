# Google Cloud Documentation https://cloud.google.com/dns/docs/zones/managed-reverse-lookup-zones

# [START dns_managed_zone_reverse_lookup]
resource "google_dns_managed_zone" "default" {
  name           = "my-new-zone"
  description    = "Example DNS reverse lookup"
  provider       = google-beta
  visibility     = "private"
  dns_name       = "2.2.20.20.in-addr.arpa."
  reverse_lookup = "true"
}
# [END dns_managed_zone_reverse_lookup]
