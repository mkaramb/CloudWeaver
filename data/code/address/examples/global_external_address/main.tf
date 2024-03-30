
# [START compute_external_ip_create]
resource "google_compute_global_address" "default" {
  project      = var.project_id # Replace this with your service project ID in quotes
  name         = "ipv6-address"
  address_type = "EXTERNAL"
  ip_version   = "IPV6"
}
# [END compute_external_ip_create]
