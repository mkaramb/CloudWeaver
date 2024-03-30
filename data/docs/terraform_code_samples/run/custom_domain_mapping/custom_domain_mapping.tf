# [START cloudrun_custom_domain_mapping_parent_tag]
# [START cloudrun_custom_domain_mapping_run_service]
resource "google_cloud_run_v2_service" "default" {
  name     = "cloud-run-srv"
  location = "us-central1"
  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
}
# [END cloudrun_custom_domain_mapping_run_service]
# [START cloudrun_custom_domain_mapping]
data "google_project" "project" {}

resource "google_cloud_run_domain_mapping" "default" {
  name     = "verified-domain.com"
  location = google_cloud_run_v2_service.default.location
  metadata {
    namespace = data.google_project.project.project_id
  }
  spec {
    route_name = google_cloud_run_v2_service.default.name
  }
}
# [END cloudrun_custom_domain_mapping]
# [END cloudrun_custom_domain_mapping_parent_tag]
