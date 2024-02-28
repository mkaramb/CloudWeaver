provider "google-beta" {
  region = "us-central1"
}

# Enable Cloud Run API
resource "google_project_service" "cloudrun_api" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

#[START cloudrun_jobs_task_timeout_create]
resource "google_cloud_run_v2_job" "default" {
  name         = "cloud-run-job-timeout"
  location     = "us-central1"
  launch_stage = "BETA"

  template {
    template {
      timeout = "3.500s"

      containers {
        image = "us-docker.pkg.dev/cloudrun/container/job:latest"
      }
    }
  }
}
#[END cloudrun_jobs_task_timeout_create]
