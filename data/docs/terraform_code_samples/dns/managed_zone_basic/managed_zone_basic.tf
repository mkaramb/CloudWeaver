# [START dns_managed_zone_basic]
resource "google_dns_managed_zone" "example_zone" {
  name        = "example-zone"
  dns_name    = "example-${random_id.rnd.hex}.com."
  description = "Example DNS zone"
  labels = {
    name = "value"
  }
}

resource "random_id" "rnd" {
  byte_length = 4
}
# [END dns_managed_zone_basic]
