provider "google-beta" {
  region = "us-central1"
}

# Enable Cloud Run API
resource "google_project_service" "cloudrun_api" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

#[START cloudrun_jobs_max_retries_create]
resource "google_cloud_run_v2_job" "default" {
  name         = "cloud-run-job-retries"
  location     = "us-central1"
  launch_stage = "BETA"

  template {
    template {
      max_retries = 3

      containers {
        image = "us-docker.pkg.dev/cloudrun/container/job:latest"
      }
    }
  }
}
#[END cloudrun_jobs_max_retries_create]
