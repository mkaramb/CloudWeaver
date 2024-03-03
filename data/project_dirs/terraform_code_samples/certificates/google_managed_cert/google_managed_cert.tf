# [START certificatemanager_google_managed_cert_parent_tag]
resource "random_id" "default" {
  byte_length = 4
}

resource "google_project_service" "default" {
  service            = "certificatemanager.googleapis.com"
  disable_on_destroy = false
}

# [START certificatemanager_google_managed_certificate]
resource "google_certificate_manager_certificate" "default" {
  name        = "prefixname-rootcert-${random_id.default.hex}"
  description = "Google-managed cert"
  managed {
    domains = ["example.me"]
  }
  labels = {
    "terraform" : true
  }
}
# [END certificatemanager_google_managed_certificate]
# [END certificatemanager_google_managed_cert_parent_tag]
