
resource "google_gke_hub_membership" "membership" {
  provider      = google-beta
  membership_id = "membership-hub-${module.gke.name}"
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${module.gke.cluster_id}"
    }
  }
}

resource "google_gke_hub_feature" "configmanagement_acm_feature" {
  name     = "configmanagement"
  location = "global"
  provider = google-beta
}

resource "google_gke_hub_feature_membership" "feature_member" {
  provider   = google-beta
  location   = "global"
  feature    = "configmanagement"
  membership = google_gke_hub_membership.membership.membership_id
  configmanagement {
    version = "1.8.0"
    config_sync {
      source_format = "unstructured"
      git {
        sync_repo   = var.sync_repo
        sync_branch = var.sync_branch
        policy_dir  = var.policy_dir
        secret_type = "none"
      }
    }
  }
  depends_on = [
    google_gke_hub_feature.configmanagement_acm_feature
  ]
}



module "enabled_google_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 14.0"

  project_id                  = var.project
  disable_services_on_destroy = false

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "gkehub.googleapis.com",
    "anthosconfigmanagement.googleapis.com"
  ]
}

module "gke" {
  source             = "terraform-google-modules/kubernetes-engine/google"
  version            = "~> 30.0"
  project_id         = module.enabled_google_apis.project_id
  name               = "sfl-acm-part1"
  region             = var.region
  zones              = [var.zone]
  initial_node_count = 4
  network            = "default"
  subnetwork         = "default"
  ip_range_pods      = ""
  ip_range_services  = ""
}
