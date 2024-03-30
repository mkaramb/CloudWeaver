provider "google-beta" {
  region = "us-central1"
}

# Enable Cloud Run API
resource "google_project_service" "cloudrun_api" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

# Create basic Cloud Run Job using sample container image
#[START cloudrun_jobs_create]
resource "google_cloud_run_v2_job" "default" {
  provider     = google-beta
  name         = "cloud-run-job"
  location     = "us-central1"
  launch_stage = "BETA"

  template {
    template {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/job:latest"
      }
    }
  }
}
#[END cloudrun_jobs_create]
