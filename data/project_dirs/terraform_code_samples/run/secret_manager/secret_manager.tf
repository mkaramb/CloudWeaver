/**
* This sample demonstrates how to deploy a Cloud Run service with a Secret
* Manager secret value assigned to an environment variable or as a mounted
* volume.
*/

# [START cloudrun_secret_manager_secret]

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.13.0"
    }
  }
}

resource "google_secret_manager_secret" "default" {
  secret_id = "my-secret"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "default" {
  secret      = google_secret_manager_secret.default.name
  secret_data = "this is secret data"
}
# [END cloudrun_secret_manager_secret]

# [START cloudrun_secret_manager_service_account_iam]
resource "google_service_account" "default" {
  account_id   = "cloud-run-service-account"
  display_name = "Service account for Cloud Run"
}

resource "google_secret_manager_secret_iam_member" "default" {
  secret_id = google_secret_manager_secret.default.id
  role      = "roles/secretmanager.secretAccessor"
  # Grant the new deployed service account access to this secret.
  member     = "serviceAccount:${google_service_account.default.email}"
  depends_on = [google_secret_manager_secret.default]
}
# [END cloudrun_secret_manager_service_account_iam]

# [START cloudrun_secret_manager_mounted]
resource "google_cloud_run_v2_service" "mounted_secret" {
  name     = "cloudrun-srv-mounted-secret"
  location = "us-central1"
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    volumes {
      name = "my-service-volume"
      secret {
        secret = google_secret_manager_secret.default.secret_id
        items {
          version = "latest"
          path    = "my-secret"
          mode    = 0 # use default 0444
        }
      }
    }
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      volume_mounts {
        name       = "my-service-volume"
        mount_path = "/secrets"
      }
    }
    service_account = google_service_account.default.email
  }
  depends_on = [google_secret_manager_secret_version.default]
}
# [END cloudrun_secret_manager_mounted]

# [START cloudrun_secret_manager_env_variable]
resource "google_cloud_run_v2_service" "env_variable_secret" {
  name     = "cloudrun-srv-env-var-secret"
  location = "us-central1"
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      env {
        name = "MY_SECRET"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.default.secret_id
            version = "latest"
          }
        }
      }
    }
    service_account = google_service_account.default.email
  }
  depends_on = [google_secret_manager_secret_version.default]
}
# [END cloudrun_secret_manager_env_variable]
