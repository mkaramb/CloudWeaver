

/******************************************
  Get available zones in region
 *****************************************/
data "google_compute_zones" "available" {
  count = local.zone_count == 0 ? 1 : 0

  provider = google-beta

  project = var.project_id
  region  = local.region
}

resource "random_shuffle" "available_zones" {
  count = local.zone_count == 0 ? 1 : 0

  input        = data.google_compute_zones.available[0].names
  result_count = 3
}

locals {
  // ID of the cluster
  cluster_id = google_container_cluster.primary.id

  // location
  location = var.regional ? var.region : var.zones[0]
  region   = var.regional ? var.region : join("-", slice(split("-", var.zones[0]), 0, 2))
  // for regional cluster - use var.zones if provided, use available otherwise, for zonal cluster use var.zones with first element extracted
  node_locations = var.regional ? coalescelist(compact(var.zones), try(sort(random_shuffle.available_zones[0].result), [])) : slice(var.zones, 1, length(var.zones))
  // Kubernetes version
  master_version_regional = var.kubernetes_version != "latest" ? var.kubernetes_version : data.google_container_engine_versions.region.latest_master_version
  master_version_zonal    = var.kubernetes_version != "latest" ? var.kubernetes_version : data.google_container_engine_versions.zone.latest_master_version
  master_version          = var.regional ? local.master_version_regional : local.master_version_zonal

  fleet_membership = var.fleet_project != null ? google_container_cluster.primary.fleet[0].membership : null

  release_channel    = var.release_channel != null ? [{ channel : var.release_channel }] : []
  gateway_api_config = var.gateway_api_channel != null ? [{ channel : var.gateway_api_channel }] : []



  custom_kube_dns_config      = length(keys(var.stub_domains)) > 0
  upstream_nameservers_config = length(var.upstream_nameservers) > 0
  network_project_id          = var.network_project_id != "" ? var.network_project_id : var.project_id
  zone_count                  = length(var.zones)
  cluster_type                = var.regional ? "regional" : "zonal"

  cluster_subnet_cidr       = var.add_cluster_firewall_rules ? data.google_compute_subnetwork.gke_subnetwork[0].ip_cidr_range : null
  cluster_alias_ranges_cidr = var.add_cluster_firewall_rules ? { for range in toset(data.google_compute_subnetwork.gke_subnetwork[0].secondary_ip_range) : range.range_name => range.ip_cidr_range } : {}
  pod_all_ip_ranges         = var.add_cluster_firewall_rules ? compact(concat([local.cluster_alias_ranges_cidr[var.ip_range_pods]], [for range in var.additional_ip_range_pods : local.cluster_alias_ranges_cidr[range] if length(range) > 0])) : []


  cluster_authenticator_security_group = var.authenticator_security_group == null ? [] : [{
    security_group = var.authenticator_security_group
  }]


  cluster_output_regional_zones = google_container_cluster.primary.node_locations
  cluster_output_zones          = local.cluster_output_regional_zones

  cluster_endpoint           = google_container_cluster.primary.endpoint
  cluster_endpoint_for_nodes = "${google_container_cluster.primary.endpoint}/32"

  cluster_output_master_auth                        = concat(google_container_cluster.primary[*].master_auth, [])
  cluster_output_master_version                     = google_container_cluster.primary.master_version
  cluster_output_min_master_version                 = google_container_cluster.primary.min_master_version
  cluster_output_logging_service                    = google_container_cluster.primary.logging_service
  cluster_output_monitoring_service                 = google_container_cluster.primary.monitoring_service
  cluster_output_http_load_balancing_enabled        = google_container_cluster.primary.addons_config[0].http_load_balancing[0].disabled
  cluster_output_horizontal_pod_autoscaling_enabled = google_container_cluster.primary.addons_config[0].horizontal_pod_autoscaling[0].disabled
  cluster_output_vertical_pod_autoscaling_enabled   = google_container_cluster.primary.vertical_pod_autoscaling != null && length(google_container_cluster.primary.vertical_pod_autoscaling) == 1 ? google_container_cluster.primary.vertical_pod_autoscaling[0].enabled : false

  # BETA features
  cluster_output_istio_disabled              = google_container_cluster.primary.addons_config[0].istio_config != null && length(google_container_cluster.primary.addons_config[0].istio_config) == 1 ? google_container_cluster.primary.addons_config[0].istio_config[0].disabled : false
  cluster_output_pod_security_policy_enabled = google_container_cluster.primary.pod_security_policy_config != null && length(google_container_cluster.primary.pod_security_policy_config) == 1 ? google_container_cluster.primary.pod_security_policy_config[0].enabled : false
  cluster_output_intranode_visbility_enabled = google_container_cluster.primary.enable_intranode_visibility

  # /BETA features

  master_authorized_networks_config = length(var.master_authorized_networks) == 0 ? [] : [{
    cidr_blocks : var.master_authorized_networks
  }]


  cluster_master_auth_list_layer1 = local.cluster_output_master_auth
  cluster_master_auth_list_layer2 = local.cluster_master_auth_list_layer1[0]
  cluster_master_auth_map         = local.cluster_master_auth_list_layer2[0]

  cluster_location = google_container_cluster.primary.location
  cluster_region   = var.regional ? var.region : join("-", slice(split("-", local.cluster_location), 0, 2))
  cluster_zones    = sort(local.cluster_output_zones)

  // cluster ID is in the form project/location/name
  cluster_name_computed                      = element(split("/", local.cluster_id), length(split("/", local.cluster_id)) - 1)
  cluster_network_tag                        = "gke-${var.name}"
  cluster_ca_certificate                     = local.cluster_master_auth_map["cluster_ca_certificate"]
  cluster_master_version                     = local.cluster_output_master_version
  cluster_min_master_version                 = local.cluster_output_min_master_version
  cluster_logging_service                    = local.cluster_output_logging_service
  cluster_monitoring_service                 = local.cluster_output_monitoring_service
  cluster_http_load_balancing_enabled        = !local.cluster_output_http_load_balancing_enabled
  cluster_horizontal_pod_autoscaling_enabled = !local.cluster_output_horizontal_pod_autoscaling_enabled
  cluster_vertical_pod_autoscaling_enabled   = local.cluster_output_vertical_pod_autoscaling_enabled
  workload_identity_enabled                  = !(var.identity_namespace == null || var.identity_namespace == "null")
  cluster_workload_identity_config = !local.workload_identity_enabled ? [] : var.identity_namespace == "enabled" ? [{
    workload_pool = "${var.project_id}.svc.id.goog" }] : [{ workload_pool = var.identity_namespace
  }]
  confidential_node_config = var.enable_confidential_nodes == true ? [{ enabled = true }] : []

  # BETA features
  cluster_istio_enabled                = !local.cluster_output_istio_disabled
  cluster_dns_cache_enabled            = var.dns_cache
  cluster_pod_security_policy_enabled  = local.cluster_output_pod_security_policy_enabled
  cluster_intranode_visibility_enabled = local.cluster_output_intranode_visbility_enabled

  # /BETA features

  cluster_maintenance_window_is_recurring = var.maintenance_recurrence != "" && var.maintenance_end_time != "" ? [1] : []
  cluster_maintenance_window_is_daily     = length(local.cluster_maintenance_window_is_recurring) > 0 ? [] : [1]
}

/******************************************
  Get available container engine versions
 *****************************************/
data "google_container_engine_versions" "region" {
  location = local.location
  project  = var.project_id
}

data "google_container_engine_versions" "zone" {
  // Work around to prevent a lack of zone declaration from causing regional cluster creation from erroring out due to error
  //
  //     data.google_container_engine_versions.zone: Cannot determine zone: set in this resource, or set provider-level zone.
  //
  location = local.zone_count == 0 ? data.google_compute_zones.available[0].names[0] : var.zones[0]
  project  = var.project_id
}




locals {
  service_account_list = compact(
    concat(
      google_service_account.cluster_service_account[*].email,
      ["dummy"],
    ),
  )
  service_account_default_name = "tf-gke-${substr(var.name, 0, min(15, length(var.name)))}-${random_string.cluster_service_account_suffix.result}"

  // if user set var.service_account it will be used even if var.create_service_account==true, so service account will be created but not used
  service_account = (var.service_account == "" || var.service_account == "create") && var.create_service_account ? local.service_account_list[0] : var.service_account

  registry_projects_list = length(var.registry_project_ids) == 0 ? [var.project_id] : var.registry_project_ids
}

resource "random_string" "cluster_service_account_suffix" {
  upper   = false
  lower   = true
  special = false
  length  = 4
}

resource "google_service_account" "cluster_service_account" {
  count        = var.create_service_account ? 1 : 0
  project      = var.project_id
  account_id   = var.service_account_name == "" ? local.service_account_default_name : var.service_account_name
  display_name = "Terraform-managed service account for cluster ${var.name}"
}

resource "google_project_iam_member" "cluster_service_account-nodeService_account" {
  count   = var.create_service_account ? 1 : 0
  project = google_service_account.cluster_service_account[0].project
  role    = "roles/container.defaultNodeServiceAccount"
  member  = google_service_account.cluster_service_account[0].member
}

resource "google_project_iam_member" "cluster_service_account-gcr" {
  for_each = var.create_service_account && var.grant_registry_access ? toset(local.registry_projects_list) : []
  project  = each.key
  role     = "roles/storage.objectViewer"
  member   = "serviceAccount:${google_service_account.cluster_service_account[0].email}"
}

resource "google_project_iam_member" "cluster_service_account-artifact-registry" {
  for_each = var.create_service_account && var.grant_registry_access ? toset(local.registry_projects_list) : []
  project  = each.key
  role     = "roles/artifactregistry.reader"
  member   = "serviceAccount:${google_service_account.cluster_service_account[0].email}"
}

resource "google_project_service_identity" "fleet_project" {
  count    = var.fleet_project_grant_service_agent ? 1 : 0
  provider = google-beta
  project  = var.fleet_project
  service  = "gkehub.googleapis.com"
}

resource "google_project_iam_member" "service_agent" {
  for_each = var.fleet_project_grant_service_agent ? toset(["roles/gkehub.serviceAgent", "roles/gkehub.crossProjectServiceAgent"]) : []
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_project_service_identity.fleet_project[0].email}"
}




/******************************************
  Create ip-masq-agent confimap
 *****************************************/
resource "kubernetes_config_map" "ip-masq-agent" {
  count = var.configure_ip_masq ? 1 : 0

  metadata {
    name      = "ip-masq-agent"
    namespace = "kube-system"

    labels = {
      maintained_by = "terraform"
    }
  }

  data = {
    config = <<EOF
nonMasqueradeCIDRs:
  - ${join("\n  - ", var.non_masquerade_cidrs)}
resyncInterval: ${var.ip_masq_resync_interval}
masqLinkLocal: ${var.ip_masq_link_local}
EOF
  }

  depends_on = [
    google_container_cluster.primary,
  ]
}




/******************************************
  Create Container Cluster
 *****************************************/
resource "google_container_cluster" "primary" {
  provider = google-beta

  name            = var.name
  description     = var.description
  project         = var.project_id
  resource_labels = var.cluster_resource_labels

  location            = local.location
  node_locations      = local.node_locations
  cluster_ipv4_cidr   = var.cluster_ipv4_cidr
  network             = "projects/${local.network_project_id}/global/networks/${var.network}"
  deletion_protection = var.deletion_protection


  dynamic "release_channel" {
    for_each = local.release_channel

    content {
      channel = release_channel.value.channel
    }
  }

  dynamic "gateway_api_config" {
    for_each = local.gateway_api_config

    content {
      channel = gateway_api_config.value.channel
    }
  }

  dynamic "cost_management_config" {
    for_each = var.enable_cost_allocation ? [1] : []
    content {
      enabled = var.enable_cost_allocation
    }
  }

  dynamic "confidential_nodes" {
    for_each = local.confidential_node_config
    content {
      enabled = confidential_nodes.value.enabled
    }
  }

  subnetwork = "projects/${local.network_project_id}/regions/${local.region}/subnetworks/${var.subnetwork}"

  default_snat_status {
    disabled = var.disable_default_snat
  }

  min_master_version = var.release_channel == null || var.release_channel == "UNSPECIFIED" ? local.master_version : var.kubernetes_version == "latest" ? null : var.kubernetes_version

  cluster_autoscaling {
    dynamic "auto_provisioning_defaults" {
      for_each = (var.create_service_account || var.service_account != "") ? [1] : []

      content {
        service_account = local.service_account
      }
    }
  }
  vertical_pod_autoscaling {
    enabled = var.enable_vertical_pod_autoscaling
  }
  enable_fqdn_network_policy = var.enable_fqdn_network_policy
  enable_autopilot           = true
  dynamic "master_authorized_networks_config" {
    for_each = local.master_authorized_networks_config
    content {
      dynamic "cidr_blocks" {
        for_each = master_authorized_networks_config.value.cidr_blocks
        content {
          cidr_block   = lookup(cidr_blocks.value, "cidr_block", "")
          display_name = lookup(cidr_blocks.value, "display_name", "")
        }
      }
    }
  }
  dynamic "node_pool_auto_config" {
    for_each = length(var.network_tags) > 0 ? [1] : []
    content {
      network_tags {
        tags = var.network_tags
      }
    }
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = var.issue_client_certificate
    }
  }

  dynamic "service_external_ips_config" {
    for_each = var.service_external_ips ? [1] : []
    content {
      enabled = var.service_external_ips
    }
  }

  addons_config {
    http_load_balancing {
      disabled = !var.http_load_balancing
    }

    horizontal_pod_autoscaling {
      disabled = !var.horizontal_pod_autoscaling
    }

  }

  allow_net_admin = var.allow_net_admin

  networking_mode = "VPC_NATIVE"

  protect_config {
    workload_config {
      audit_mode = var.workload_config_audit_mode
    }
    workload_vulnerability_mode = var.workload_vulnerability_mode
  }

  security_posture_config {
    mode               = var.security_posture_mode
    vulnerability_mode = var.security_posture_vulnerability_mode
  }

  dynamic "fleet" {
    for_each = var.fleet_project != null ? [1] : []
    content {
      project = var.fleet_project
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.ip_range_pods
    services_secondary_range_name = var.ip_range_services
    dynamic "additional_pod_ranges_config" {
      for_each = length(var.additional_ip_range_pods) != 0 ? [1] : []
      content {
        pod_range_names = var.additional_ip_range_pods
      }
    }
    stack_type = var.stack_type
  }

  maintenance_policy {
    dynamic "recurring_window" {
      for_each = local.cluster_maintenance_window_is_recurring
      content {
        start_time = var.maintenance_start_time
        end_time   = var.maintenance_end_time
        recurrence = var.maintenance_recurrence
      }
    }

    dynamic "daily_maintenance_window" {
      for_each = local.cluster_maintenance_window_is_daily
      content {
        start_time = var.maintenance_start_time
      }
    }

    dynamic "maintenance_exclusion" {
      for_each = var.maintenance_exclusions
      content {
        exclusion_name = maintenance_exclusion.value.name
        start_time     = maintenance_exclusion.value.start_time
        end_time       = maintenance_exclusion.value.end_time

        dynamic "exclusion_options" {
          for_each = maintenance_exclusion.value.exclusion_scope == null ? [] : [maintenance_exclusion.value.exclusion_scope]
          content {
            scope = exclusion_options.value
          }
        }
      }
    }
  }


  timeouts {
    create = lookup(var.timeouts, "create", "45m")
    update = lookup(var.timeouts, "update", "45m")
    delete = lookup(var.timeouts, "delete", "45m")
  }

  dynamic "resource_usage_export_config" {
    for_each = var.resource_usage_export_dataset_id != "" ? [{
      enable_network_egress_metering       = var.enable_network_egress_export
      enable_resource_consumption_metering = var.enable_resource_consumption_export
      dataset_id                           = var.resource_usage_export_dataset_id
    }] : []

    content {
      enable_network_egress_metering       = resource_usage_export_config.value.enable_network_egress_metering
      enable_resource_consumption_metering = resource_usage_export_config.value.enable_resource_consumption_metering
      bigquery_destination {
        dataset_id = resource_usage_export_config.value.dataset_id
      }
    }
  }



  dynamic "database_encryption" {
    for_each = var.database_encryption

    content {
      key_name = database_encryption.value.key_name
      state    = database_encryption.value.state
    }
  }



  dynamic "authenticator_groups_config" {
    for_each = local.cluster_authenticator_security_group
    content {
      security_group = authenticator_groups_config.value.security_group
    }
  }

  notification_config {
    pubsub {
      enabled = var.notification_config_topic != "" ? true : false
      topic   = var.notification_config_topic
    }
  }

  depends_on = [google_project_iam_member.service_agent]
}




# Setup dynamic default values for variables which can't be setup using
# the standard terraform "variable default" functionality





data "google_compute_subnetwork" "gke_subnetwork" {
  provider = google

  count   = var.add_cluster_firewall_rules ? 1 : 0
  name    = var.subnetwork
  region  = local.region
  project = local.network_project_id
}





/******************************************
  Match the gke-<CLUSTER>-<ID>-all INGRESS
  firewall rule created by GKE but for EGRESS

  Required for clusters when VPCs enforce
  a default-deny egress rule
 *****************************************/
resource "google_compute_firewall" "intra_egress" {
  count       = var.add_cluster_firewall_rules ? 1 : 0
  name        = "gke-${substr(var.name, 0, min(36, length(var.name)))}-intra-cluster-egress"
  description = "Managed by terraform gke module: Allow pods to communicate with each other and the master"
  project     = local.network_project_id
  network     = var.network
  priority    = var.firewall_priority
  direction   = "EGRESS"

  target_tags = [local.cluster_network_tag]
  destination_ranges = concat([
    local.cluster_endpoint_for_nodes,
    local.cluster_subnet_cidr,
    ],
    local.pod_all_ip_ranges
  )

  # Allow all possible protocols
  allow { protocol = "tcp" }
  allow { protocol = "udp" }
  allow { protocol = "icmp" }
  allow { protocol = "sctp" }
  allow { protocol = "esp" }
  allow { protocol = "ah" }

  depends_on = [
    google_container_cluster.primary,
  ]
}


/******************************************
  Allow egress to the TPU IPv4 CIDR block

  This rule is defined separately from the
  intra_egress rule above since it requires
  an output from the google_container_cluster
  resource.

  https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1124
 *****************************************/
resource "google_compute_firewall" "tpu_egress" {
  count       = var.add_cluster_firewall_rules && var.enable_tpu ? 1 : 0
  name        = "gke-${substr(var.name, 0, min(36, length(var.name)))}-tpu-egress"
  description = "Managed by terraform gke module: Allow pods to communicate with TPUs"
  project     = local.network_project_id
  network     = var.network
  priority    = var.firewall_priority
  direction   = "EGRESS"

  target_tags        = [local.cluster_network_tag]
  destination_ranges = [google_container_cluster.primary.tpu_ipv4_cidr_block]

  # Allow all possible protocols
  allow { protocol = "tcp" }
  allow { protocol = "udp" }
  allow { protocol = "icmp" }
  allow { protocol = "sctp" }
  allow { protocol = "esp" }
  allow { protocol = "ah" }

  depends_on = [
    google_container_cluster.primary,
  ]
}

/******************************************
  Allow GKE master to hit non 443 ports for
  Webhooks/Admission Controllers

  https://github.com/kubernetes/kubernetes/issues/79739
 *****************************************/
resource "google_compute_firewall" "master_webhooks" {
  count       = var.add_cluster_firewall_rules || var.add_master_webhook_firewall_rules ? 1 : 0
  name        = "gke-${substr(var.name, 0, min(36, length(var.name)))}-webhooks"
  description = "Managed by terraform gke module: Allow master to hit pods for admission controllers/webhooks"
  project     = local.network_project_id
  network     = var.network
  priority    = var.firewall_priority
  direction   = "INGRESS"

  source_ranges = [local.cluster_endpoint_for_nodes]
  source_tags   = []
  target_tags   = [local.cluster_network_tag]

  allow {
    protocol = "tcp"
    ports    = var.firewall_inbound_ports
  }

  depends_on = [
    google_container_cluster.primary,
  ]

}


/******************************************
  Create shadow firewall rules to capture the
  traffic flow between the managed firewall rules
 *****************************************/
resource "google_compute_firewall" "shadow_allow_pods" {
  count = var.add_shadow_firewall_rules ? 1 : 0

  name        = "gke-shadow-${substr(var.name, 0, min(36, length(var.name)))}-all"
  description = "Managed by terraform gke module: A shadow firewall rule to match the default rule allowing pod communication."
  project     = local.network_project_id
  network     = var.network
  priority    = var.shadow_firewall_rules_priority
  direction   = "INGRESS"

  source_ranges = local.pod_all_ip_ranges
  target_tags   = [local.cluster_network_tag]

  # Allow all possible protocols
  allow { protocol = "tcp" }
  allow { protocol = "udp" }
  allow { protocol = "icmp" }
  allow { protocol = "sctp" }
  allow { protocol = "esp" }
  allow { protocol = "ah" }

  dynamic "log_config" {
    for_each = var.shadow_firewall_rules_log_config == null ? [] : [var.shadow_firewall_rules_log_config]
    content {
      metadata = log_config.value.metadata
    }
  }
}

resource "google_compute_firewall" "shadow_allow_master" {
  count = var.add_shadow_firewall_rules ? 1 : 0

  name        = "gke-shadow-${substr(var.name, 0, min(36, length(var.name)))}-master"
  description = "Managed by terraform GKE module: A shadow firewall rule to match the default rule allowing worker nodes communication."
  project     = local.network_project_id
  network     = var.network
  priority    = var.shadow_firewall_rules_priority
  direction   = "INGRESS"

  source_ranges = [local.cluster_endpoint_for_nodes]
  target_tags   = [local.cluster_network_tag]

  allow {
    protocol = "tcp"
    ports    = ["10250", "443"]
  }

  dynamic "log_config" {
    for_each = var.shadow_firewall_rules_log_config == null ? [] : [var.shadow_firewall_rules_log_config]
    content {
      metadata = log_config.value.metadata
    }
  }
}

resource "google_compute_firewall" "shadow_allow_nodes" {
  count = var.add_shadow_firewall_rules ? 1 : 0

  name        = "gke-shadow-${substr(var.name, 0, min(36, length(var.name)))}-vms"
  description = "Managed by Terraform GKE module: A shadow firewall rule to match the default rule allowing worker nodes communication."
  project     = local.network_project_id
  network     = var.network
  priority    = var.shadow_firewall_rules_priority
  direction   = "INGRESS"

  source_ranges = [local.cluster_subnet_cidr]
  target_tags   = [local.cluster_network_tag]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "udp"
    ports    = ["1-65535"]
  }

  allow {
    protocol = "tcp"
    ports    = ["1-65535"]
  }

  dynamic "log_config" {
    for_each = var.shadow_firewall_rules_log_config == null ? [] : [var.shadow_firewall_rules_log_config]
    content {
      metadata = log_config.value.metadata
    }
  }
}

resource "google_compute_firewall" "shadow_allow_inkubelet" {
  count = var.add_shadow_firewall_rules ? 1 : 0

  name        = "gke-shadow-${substr(var.name, 0, min(36, length(var.name)))}-inkubelet"
  description = "Managed by terraform GKE module: A shadow firewall rule to match the default rule allowing worker nodes & pods communication to kubelet."
  project     = local.network_project_id
  network     = var.network
  priority    = var.shadow_firewall_rules_priority - 1 # rule created by GKE robot have prio 999
  direction   = "INGRESS"

  source_ranges = local.pod_all_ip_ranges
  source_tags   = [local.cluster_network_tag]
  target_tags   = [local.cluster_network_tag]

  allow {
    protocol = "tcp"
    ports    = ["10255"]
  }

  dynamic "log_config" {
    for_each = var.shadow_firewall_rules_log_config == null ? [] : [var.shadow_firewall_rules_log_config]
    content {
      metadata = log_config.value.metadata
    }
  }
}

resource "google_compute_firewall" "shadow_deny_exkubelet" {
  count = var.add_shadow_firewall_rules ? 1 : 0

  name        = "gke-shadow-${substr(var.name, 0, min(36, length(var.name)))}-exkubelet"
  description = "Managed by terraform GKE module: A shadow firewall rule to match the default deny rule to kubelet."
  project     = local.network_project_id
  network     = var.network
  priority    = var.shadow_firewall_rules_priority # rule created by GKE robot have prio 1000
  direction   = "INGRESS"

  source_ranges = ["0.0.0.0/0"]
  target_tags   = [local.cluster_network_tag]

  deny {
    protocol = "tcp"
    ports    = ["10255"]
  }

  dynamic "log_config" {
    for_each = var.shadow_firewall_rules_log_config == null ? [] : [var.shadow_firewall_rules_log_config]
    content {
      metadata = log_config.value.metadata
    }
  }
}




/******************************************
  Manage kube-dns configmaps
 *****************************************/

resource "kubernetes_config_map_v1_data" "kube-dns" {
  count = local.custom_kube_dns_config && !local.upstream_nameservers_config ? 1 : 0

  metadata {
    name      = "kube-dns"
    namespace = "kube-system"
  }

  data = {
    stubDomains = <<EOF
${jsonencode(var.stub_domains)}
EOF
  }

  force = true

  depends_on = [
    google_container_cluster.primary,
  ]
}

resource "kubernetes_config_map_v1_data" "kube-dns-upstream-namservers" {
  count = !local.custom_kube_dns_config && local.upstream_nameservers_config ? 1 : 0

  metadata {
    name      = "kube-dns"
    namespace = "kube-system"
  }

  data = {
    upstreamNameservers = <<EOF
${jsonencode(var.upstream_nameservers)}
EOF
  }

  force = true

  depends_on = [
    google_container_cluster.primary,
  ]
}

resource "kubernetes_config_map_v1_data" "kube-dns-upstream-nameservers-and-stub-domains" {
  count = local.custom_kube_dns_config && local.upstream_nameservers_config ? 1 : 0

  metadata {
    name      = "kube-dns"
    namespace = "kube-system"
  }

  data = {
    upstreamNameservers = <<EOF
${jsonencode(var.upstream_nameservers)}
EOF

    stubDomains = <<EOF
${jsonencode(var.stub_domains)}
EOF
  }

  force = true

  depends_on = [
    google_container_cluster.primary,
  ]
}
