
/*********************************************
  Module dns_zone_iam_binding calling
 *********************************************/
module "dns_zones_iam_binding" {
  source  = "terraform-google-modules/iam/google//modules/dns_zones_iam"
  version = "~> 7.0"

  project = var.project_id
  managed_zones = [
    google_dns_managed_zone.dns_zone_one.name,
  ]
  mode = "authoritative"

  bindings = {
    "roles/viewer" = [
      "serviceAccount:${var.sa_email}",
      "group:${var.group_email}",
      "user:${var.user_email}",
    ]
    "roles/dns.reader" = [
      "serviceAccount:${var.sa_email}",
      "group:${var.group_email}",
      "user:${var.user_email}",
    ]
  }
}

resource "google_dns_managed_zone" "dns_zone_one" {
  project  = var.project_id
  name     = "test-iam-dns-${random_id.test.hex}-one"
  dns_name = "example-${random_id.test.hex}.com."
}

resource "random_id" "test" {
  byte_length = 4
}
