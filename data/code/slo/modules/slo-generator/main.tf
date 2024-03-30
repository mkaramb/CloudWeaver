
locals {
  service_account_email = var.service_account_email == "" ? "${data.google_project.project.number}-compute@developer.gserviceaccount.com" : var.service_account_email
  bucket_name           = var.bucket_name != "" ? var.bucket_name : "slo-generator-${random_id.suffix.hex}"
  service_url           = var.create_service ? join("", google_cloud_run_service.service[0].status.*.url) : var.service_url
  default_annotations = {
    "autoscaling.knative.dev/minScale" = "1"
    "autoscaling.knative.dev/maxScale" = "100"
  }
}

resource "random_id" "suffix" {
  byte_length = 6
}

resource "google_storage_bucket" "slos" {
  project       = var.project_id
  name          = local.bucket_name
  location      = var.region
  force_destroy = true
  labels        = var.labels
}

resource "google_storage_bucket_object" "shared_config" {
  name    = "config.yaml"
  content = yamlencode(var.config)
  bucket  = google_storage_bucket.slos.name
}

resource "google_storage_bucket_object" "slos" {
  for_each = { for config in var.slo_configs : config.metadata.name => config }
  name     = "slos/${each.key}.yaml"
  content  = yamlencode(each.value)
  bucket   = google_storage_bucket.slos.name
}

resource "google_cloud_scheduler_job" "scheduler" {
  for_each = { for config in var.slo_configs : config.metadata.name => config if var.create_cloud_schedulers }
  project  = var.project_id
  region   = var.region
  schedule = var.schedule
  name     = each.key
  http_target {
    oidc_token {
      service_account_email = local.service_account_email
      audience              = local.service_url
    }
    http_method = "POST"
    uri         = "${local.service_url}/"
    body        = base64encode("gs://${local.bucket_name}/slos/${each.key}.yaml")
  }
}

resource "google_cloud_run_service" "service" {
  count                      = var.create_service ? 1 : 0
  name                       = var.service_name
  location                   = var.region
  project                    = var.project_id
  autogenerate_revision_name = true
  provider                   = google-beta

  metadata {
    annotations = {
      "run.googleapis.com/ingress" = var.ingress
    }
  }

  template {
    metadata {
      annotations = merge(local.default_annotations, var.annotations)
      labels      = var.labels
    }
    spec {
      service_account_name  = local.service_account_email
      container_concurrency = var.concurrency
      containers {
        image   = "gcr.io/${var.gcr_project_id}/slo-generator:${var.slo_generator_version}"
        command = ["slo-generator"]
        args = [
          "api",
          "--signature-type=${var.signature_type}",
          "--target=${var.target}"
        ]
        env {
          name  = "CONFIG_PATH"
          value = "gs://${google_storage_bucket.slos.name}/config.yaml"
        }
        dynamic "env" {
          for_each = var.env
          content {
            name  = env.key
            value = env.value
          }
        }
        dynamic "env" {
          for_each = google_secret_manager_secret.secret
          content {
            name = env.value.secret_id
            value_from {
              secret_key_ref {
                name = env.value.secret_id
                key  = "latest"
              }
            }
          }
        }
        resources {
          requests = var.requests
          limits   = var.limits
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [
    google_project_iam_member.sa-roles,
    google_secret_manager_secret_version.secret-version-data
  ]
}



data "google_project" "project" {
  project_id = var.project_id
}

resource "google_secret_manager_secret" "secret" {
  for_each  = var.secrets
  provider  = google-beta
  project   = var.project_id
  secret_id = each.key
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_iam_member" "secret-access" {
  for_each  = google_secret_manager_secret.secret
  provider  = google-beta
  project   = var.project_id
  secret_id = each.value.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${local.service_account_email}"
}

resource "google_secret_manager_secret_version" "secret-version-data" {
  for_each    = google_secret_manager_secret.secret
  provider    = google-beta
  secret      = each.value.id
  secret_data = var.secrets[each.key]
}





locals {
  roles = concat([
    "roles/monitoring.viewer",
    "roles/monitoring.metricWriter",
    "roles/run.invoker",
    "roles/secretmanager.secretAccessor",
    "roles/storage.admin",
  ], var.additional_project_roles)
}

resource "google_project_iam_member" "sa-roles" {
  count   = var.create_iam_roles ? length(local.roles) : 0
  project = var.project_id
  role    = local.roles[count.index]
  member  = "serviceAccount:${local.service_account_email}"
}

resource "google_cloud_run_service_iam_member" "run-invokers" {
  count    = var.create_iam_roles ? length(var.authorized_members) : 0
  location = google_cloud_run_service.service[0].location
  project  = google_cloud_run_service.service[0].project
  service  = google_cloud_run_service.service[0].name
  role     = "roles/run.invoker"
  member   = var.authorized_members[count.index]
}
