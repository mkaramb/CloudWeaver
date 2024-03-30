# ca pool to use in privateca samples
resource "google_privateca_ca_pool" "default" {
  count = local.num_projects

  project  = local.project_ids[count.index]
  name     = "my-pool"
  location = "us-central1"
  tier     = "ENTERPRISE"
  publishing_options {
    publish_ca_cert = true
    publish_crl     = true
  }
}
