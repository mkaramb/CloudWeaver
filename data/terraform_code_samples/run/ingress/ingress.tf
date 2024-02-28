provider "google-beta" {
  region = "us-central1"
}

# Enable Cloud Run API
resource "google_project_service" "cloudrun_api" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

# [START cloudrun_service_ingress]
resource "google_cloud_run_v2_service" "default" {
  provider = google-beta
  name     = "ingress-service"
  location = "us-central1"

  # For valid annotation values and descriptions, see
  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service#ingress
  ingress = "INGRESS_TRAFFIC_INTERNAL_ONLY"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello" #public image for your service
    }
  }
  # [END cloudrun_service_ingress]
  # Used in sample testing. These fields may change in 'terraform plan' output, which is expected and thus non-blocking.
  lifecycle {
    ignore_changes = [
      ingress
    ]
  }
  # [START cloudrun_service_ingress]
}
# [END cloudrun_service_ingress]
