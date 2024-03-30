
locals {
  private_key            = var.create_ssh_key && var.ssh_auth_key == null ? tls_private_key.k8sop_creds[0].private_key_pem : var.ssh_auth_key
  k8sop_creds_secret_key = var.secret_type == "cookiefile" ? "cookie_file" : var.secret_type
}

module "registration" {
  source = "../fleet-membership"

  cluster_name              = var.cluster_name
  project_id                = var.project_id
  location                  = var.location
  enable_fleet_registration = var.enable_fleet_registration
  membership_name           = var.cluster_membership_id
}



module "policy_bundles" {
  source  = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version = "~> 3.1"

  for_each                = toset(var.policy_bundles)
  project_id              = var.project_id
  cluster_name            = var.cluster_name
  cluster_location        = var.location
  kubectl_create_command  = "kubectl apply -k ${each.key}"
  kubectl_destroy_command = "kubectl delete -k ${each.key}"

  module_depends_on = [time_sleep.wait_acm]
}



resource "google_gke_hub_feature" "acm" {
  count    = var.enable_fleet_feature ? 1 : 0
  provider = google-beta

  name     = "configmanagement"
  project  = var.project_id
  location = "global"
}

resource "google_gke_hub_feature_membership" "main" {
  provider = google-beta
  depends_on = [
    google_gke_hub_feature.acm
  ]

  location = "global"
  feature  = "configmanagement"

  membership = module.registration.cluster_membership_id
  project    = var.project_id

  configmanagement {
    version = var.configmanagement_version

    dynamic "config_sync" {
      for_each = var.enable_config_sync ? [{ enabled = true }] : []

      content {
        source_format = var.source_format != "" ? var.source_format : null

        git {
          sync_repo                 = var.sync_repo
          policy_dir                = var.policy_dir != "" ? var.policy_dir : null
          sync_branch               = var.sync_branch != "" ? var.sync_branch : null
          sync_rev                  = var.sync_revision != "" ? var.sync_revision : null
          secret_type               = var.secret_type
          https_proxy               = var.https_proxy
          gcp_service_account_email = var.gcp_service_account_email
        }
      }
    }

    dynamic "policy_controller" {
      for_each = var.enable_policy_controller ? [{ enabled = true }] : []

      content {
        enabled                    = true
        mutation_enabled           = var.enable_mutation
        referential_rules_enabled  = var.enable_referential_rules
        template_library_installed = var.install_template_library
        log_denies_enabled         = var.enable_log_denies
      }
    }

    dynamic "hierarchy_controller" {
      for_each = var.hierarchy_controller == null ? [] : [var.hierarchy_controller]

      content {
        enabled                            = true
        enable_hierarchical_resource_quota = each.value.enable_hierarchical_resource_quota
        enable_pod_tree_labels             = each.value.enable_pod_tree_labels
      }
    }
  }
}



locals {
  # GCP service account ids must be <= 30 chars matching regex ^[a-z](?:[-a-z0-9]{4,28}[a-z0-9])$
  service_account_name = trimsuffix(substr(var.metrics_gcp_sa_name, 0, 30), "-")

  iam_ksa_binding_members = var.create_metrics_gcp_sa ? concat(
    var.enable_config_sync ? ["config-management-monitoring/default"] : [],
    var.enable_policy_controller ? ["gatekeeper-system/gatekeeper-admin"] : [],
  ) : []
}

resource "tls_private_key" "k8sop_creds" {
  count     = var.create_ssh_key ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Wait for ACM
resource "time_sleep" "wait_acm" {
  count      = (var.create_ssh_key == true || var.ssh_auth_key != null || var.enable_policy_controller || var.enable_config_sync) ? 1 : 0
  depends_on = [google_gke_hub_feature_membership.main]

  create_duration = "600s"
}

resource "google_service_account_iam_binding" "ksa_iam" {
  count      = length(local.iam_ksa_binding_members) > 0 ? 1 : 0
  depends_on = [google_gke_hub_feature_membership.main]

  service_account_id = google_service_account.acm_metrics_writer_sa[0].name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    for ksa in local.iam_ksa_binding_members : "serviceAccount:${var.project_id}.svc.id.goog[${ksa}]"
  ]
}

resource "kubernetes_annotations" "annotate-sa-config-management-monitoring" {
  count = var.enable_config_sync && var.create_metrics_gcp_sa ? 1 : 0

  api_version = "v1"
  kind        = "ServiceAccount"

  metadata {
    name      = "default"
    namespace = "config-management-monitoring"
  }

  annotations = {
    "iam.gke.io/gcp-service-account" : google_service_account.acm_metrics_writer_sa[0].email
  }

  depends_on = [time_sleep.wait_acm]
}

resource "kubernetes_annotations" "annotate-sa-gatekeeper-system" {
  count      = var.enable_policy_controller && var.create_metrics_gcp_sa ? 1 : 0
  depends_on = [time_sleep.wait_acm]

  api_version = "v1"
  kind        = "ServiceAccount"

  metadata {
    name      = "gatekeeper-admin"
    namespace = "gatekeeper-system"
  }

  annotations = {
    "iam.gke.io/gcp-service-account" : google_service_account.acm_metrics_writer_sa[0].email
  }
}

resource "time_static" "restarted_at" {}
resource "kubernetes_annotations" "annotate-sa-gatekeeper-system-restart" {
  count = var.enable_policy_controller && var.create_metrics_gcp_sa ? 1 : 0

  api_version = "apps/v1"
  kind        = "Deployment"
  metadata {
    name      = "gatekeeper-controller-manager"
    namespace = "gatekeeper-system"
  }
  template_annotations = {
    "kubectl.kubernetes.io/restartedAt" = time_static.restarted_at.rfc3339
  }

  depends_on = [kubernetes_annotations.annotate-sa-gatekeeper-system]
}

resource "google_service_account" "acm_metrics_writer_sa" {
  count = var.create_metrics_gcp_sa ? 1 : 0

  display_name = "ACM Metrics Writer SA"
  account_id   = local.service_account_name
  project      = var.project_id
}

resource "google_project_iam_member" "acm_metrics_writer_sa_role" {
  count   = var.create_metrics_gcp_sa ? 1 : 0
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.acm_metrics_writer_sa[0].email}"
}

resource "kubernetes_secret_v1" "creds" {
  count      = (var.create_ssh_key == true || var.ssh_auth_key != null) ? 1 : 0
  depends_on = [time_sleep.wait_acm]

  metadata {
    name      = "git-creds"
    namespace = "config-management-system"
  }

  data = {
    (local.k8sop_creds_secret_key) = local.private_key
  }
}
