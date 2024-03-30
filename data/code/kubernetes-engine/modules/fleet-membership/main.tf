
locals {
  hub_project_id                   = var.hub_project_id == "" ? var.project_id : var.hub_project_id
  gke_hub_membership_name_complete = var.membership_name != "" ? var.membership_name : "${var.project_id}-${var.location}-${var.cluster_name}"
  gke_hub_membership_name          = trimsuffix(substr(local.gke_hub_membership_name_complete, 0, 63), "-")
  gke_hub_membership_location      = try(regex(local.gke_hub_membership_location_re, data.google_container_cluster.primary.fleet[0].membership)[0], null)
  gke_hub_membership_location_re   = "//gkehub.googleapis.com/projects/[^/]*/locations/([^/]*)/memberships/[^/]*$"
}

# Retrieve GKE cluster info
data "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.location
  project  = var.project_id
}

# Give the service agent permissions on hub project
resource "google_project_iam_member" "hub_service_agent_gke" {
  count   = var.hub_project_id == "" ? 0 : 1
  project = var.hub_project_id
  role    = "roles/gkehub.serviceAgent"
  member  = "serviceAccount:${google_project_service_identity.sa_gkehub[0].email}"
}

resource "google_project_iam_member" "hub_service_agent_hub" {
  count   = var.hub_project_id == "" ? 0 : 1
  project = local.hub_project_id
  role    = "roles/gkehub.serviceAgent"
  member  = "serviceAccount:${google_project_service_identity.sa_gkehub[0].email}"
}

resource "google_project_service_identity" "sa_gkehub" {
  count    = var.hub_project_id == "" ? 0 : 1
  provider = google-beta
  project  = local.hub_project_id
  service  = "gkehub.googleapis.com"
}



# Create the membership
resource "google_gke_hub_membership" "primary" {
  count    = var.enable_fleet_registration ? 1 : 0
  provider = google-beta

  project       = local.hub_project_id
  membership_id = local.gke_hub_membership_name
  location      = var.membership_location

  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${data.google_container_cluster.primary.id}"
    }
  }
  authority {
    issuer = "https://container.googleapis.com/v1/${data.google_container_cluster.primary.id}"
  }
}
