

/******************************************
  Get available zones in region
 *****************************************/
data "google_compute_zones" "available" {
  count = local.zone_count == 0 ? 1 : 0

  provider = google

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
  // Build a map of maps of node pools from a list of objects
  node_pool_names         = [for np in toset(var.node_pools) : np.name]
  node_pools              = zipmap(local.node_pool_names, tolist(toset(var.node_pools)))
  windows_node_pool_names = [for np in toset(var.windows_node_pools) : np.name]
  windows_node_pools      = zipmap(local.windows_node_pool_names, tolist(toset(var.windows_node_pools)))

  fleet_membership = var.fleet_project != null ? google_container_cluster.primary.fleet[0].membership : null

  release_channel    = var.release_channel != null ? [{ channel : var.release_channel }] : []
  gateway_api_config = var.gateway_api_channel != null ? [{ channel : var.gateway_api_channel }] : []

  autoscaling_resource_limits = var.cluster_autoscaling.enabled ? concat([{
    resource_type = "cpu"
    minimum       = var.cluster_autoscaling.min_cpu_cores
    maximum       = var.cluster_autoscaling.max_cpu_cores
    }, {
    resource_type = "memory"
    minimum       = var.cluster_autoscaling.min_memory_gb
    maximum       = var.cluster_autoscaling.max_memory_gb
  }], var.cluster_autoscaling.gpu_resources) : []


  custom_kube_dns_config      = length(keys(var.stub_domains)) > 0
  upstream_nameservers_config = length(var.upstream_nameservers) > 0
  network_project_id          = var.network_project_id != "" ? var.network_project_id : var.project_id
  zone_count                  = length(var.zones)
  cluster_type                = var.regional ? "regional" : "zonal"
  // auto upgrade by defaults only for regional cluster as long it has multiple masters versus zonal clusters have only have a single master so upgrades are more dangerous.
  // When a release channel is used, node auto-upgrade is enabled and cannot be disabled.
  default_auto_upgrade = var.regional || var.release_channel != "UNSPECIFIED" ? true : false

  cluster_subnet_cidr       = var.add_cluster_firewall_rules ? data.google_compute_subnetwork.gke_subnetwork[0].ip_cidr_range : null
  cluster_alias_ranges_cidr = var.add_cluster_firewall_rules ? { for range in toset(data.google_compute_subnetwork.gke_subnetwork[0].secondary_ip_range) : range.range_name => range.ip_cidr_range } : {}
  pod_all_ip_ranges         = var.add_cluster_firewall_rules ? compact(concat([local.cluster_alias_ranges_cidr[var.ip_range_pods]], [for range in var.additional_ip_range_pods : local.cluster_alias_ranges_cidr[range] if length(range) > 0], [for k, v in merge(local.node_pools, local.windows_node_pools) : local.cluster_alias_ranges_cidr[v.pod_range] if length(lookup(v, "pod_range", "")) > 0])) : []

  cluster_network_policy = var.network_policy ? [{
    enabled  = true
    provider = var.network_policy_provider
    }] : [{
    enabled  = false
    provider = null
  }]
  cluster_gce_pd_csi_config  = var.gce_pd_csi_driver ? [{ enabled = true }] : [{ enabled = false }]
  logmon_config_is_set       = length(var.logging_enabled_components) > 0 || length(var.monitoring_enabled_components) > 0 || var.monitoring_enable_managed_prometheus
  gke_backup_agent_config    = var.gke_backup_agent_config ? [{ enabled = true }] : [{ enabled = false }]
  gcs_fuse_csi_driver_config = var.gcs_fuse_csi_driver ? [{ enabled = true }] : []

  cluster_authenticator_security_group = var.authenticator_security_group == null ? [] : [{
    security_group = var.authenticator_security_group
  }]

  // legacy mappings https://github.com/hashicorp/terraform-provider-google/pull/10238
  old_node_metadata_config_mapping = { GKE_METADATA_SERVER = "GKE_METADATA", EXPOSE = "GCE_METADATA" }

  cluster_node_metadata_config = var.node_metadata == "UNSPECIFIED" ? [] : [{
    mode = lookup(local.old_node_metadata_config_mapping, var.node_metadata, var.node_metadata)
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
  cluster_output_network_policy_enabled             = google_container_cluster.primary.addons_config[0].network_policy_config[0].disabled
  cluster_output_http_load_balancing_enabled        = google_container_cluster.primary.addons_config[0].http_load_balancing[0].disabled
  cluster_output_horizontal_pod_autoscaling_enabled = google_container_cluster.primary.addons_config[0].horizontal_pod_autoscaling[0].disabled
  cluster_output_vertical_pod_autoscaling_enabled   = google_container_cluster.primary.vertical_pod_autoscaling != null && length(google_container_cluster.primary.vertical_pod_autoscaling) == 1 ? google_container_cluster.primary.vertical_pod_autoscaling[0].enabled : false


  master_authorized_networks_config = length(var.master_authorized_networks) == 0 ? [] : [{
    cidr_blocks : var.master_authorized_networks
  }]

  cluster_output_node_pools_names = concat(
    [for np in google_container_node_pool.pools : np.name], [""],
    [for np in google_container_node_pool.windows_pools : np.name], [""]
  )

  cluster_output_node_pools_versions = merge(
    { for np in google_container_node_pool.pools : np.name => np.version },
    { for np in google_container_node_pool.windows_pools : np.name => np.version },
  )

  cluster_master_auth_list_layer1 = local.cluster_output_master_auth
  cluster_master_auth_list_layer2 = local.cluster_master_auth_list_layer1[0]
  cluster_master_auth_map         = local.cluster_master_auth_list_layer2[0]

  cluster_location = google_container_cluster.primary.location
  cluster_region   = var.regional ? var.region : join("-", slice(split("-", local.cluster_location), 0, 2))
  cluster_zones    = sort(local.cluster_output_zones)

  // node pool ID is in the form projects/<project-id>/locations/<location>/clusters/<cluster-name>/nodePools/<nodepool-name>
  cluster_name_parts_from_nodepool           = split("/", element(values(google_container_node_pool.pools)[*].id, 0))
  cluster_name_computed                      = element(local.cluster_name_parts_from_nodepool, length(local.cluster_name_parts_from_nodepool) - 3)
  cluster_network_tag                        = "gke-${var.name}"
  cluster_ca_certificate                     = local.cluster_master_auth_map["cluster_ca_certificate"]
  cluster_master_version                     = local.cluster_output_master_version
  cluster_min_master_version                 = local.cluster_output_min_master_version
  cluster_logging_service                    = local.cluster_output_logging_service
  cluster_monitoring_service                 = local.cluster_output_monitoring_service
  cluster_node_pools_names                   = local.cluster_output_node_pools_names
  cluster_node_pools_versions                = local.cluster_output_node_pools_versions
  cluster_network_policy_enabled             = !local.cluster_output_network_policy_enabled
  cluster_http_load_balancing_enabled        = !local.cluster_output_http_load_balancing_enabled
  cluster_horizontal_pod_autoscaling_enabled = !local.cluster_output_horizontal_pod_autoscaling_enabled
  cluster_vertical_pod_autoscaling_enabled   = local.cluster_output_vertical_pod_autoscaling_enabled
  workload_identity_enabled                  = !(var.identity_namespace == null || var.identity_namespace == "null")
  cluster_workload_identity_config = !local.workload_identity_enabled ? [] : var.identity_namespace == "enabled" ? [{
    workload_pool = "${var.project_id}.svc.id.goog" }] : [{ workload_pool = var.identity_namespace
  }]
  confidential_node_config = var.enable_confidential_nodes == true ? [{ enabled = true }] : []
  cluster_mesh_certificates_config = local.workload_identity_enabled ? [{
    enable_certificates = var.enable_mesh_certificates
  }] : []


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
    google_container_node_pool.pools,
  ]
}




/******************************************
  Create Container Cluster
 *****************************************/
resource "google_container_cluster" "primary" {
  provider = google

  name            = var.name
  description     = var.description
  project         = var.project_id
  resource_labels = var.cluster_resource_labels

  location            = local.location
  node_locations      = local.node_locations
  cluster_ipv4_cidr   = var.cluster_ipv4_cidr
  network             = "projects/${local.network_project_id}/global/networks/${var.network}"
  deletion_protection = var.deletion_protection

  dynamic "network_policy" {
    for_each = local.cluster_network_policy

    content {
      enabled  = network_policy.value.enabled
      provider = network_policy.value.provider
    }
  }

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

  # only one of logging/monitoring_service or logging/monitoring_config can be specified
  logging_service = local.logmon_config_is_set ? null : var.logging_service
  dynamic "logging_config" {
    for_each = length(var.logging_enabled_components) > 0 ? [1] : []

    content {
      enable_components = var.logging_enabled_components
    }
  }
  monitoring_service = local.logmon_config_is_set ? null : var.monitoring_service
  dynamic "monitoring_config" {
    for_each = local.logmon_config_is_set || local.logmon_config_is_set ? [1] : []
    content {
      enable_components = var.monitoring_enabled_components
      managed_prometheus {
        enabled = var.monitoring_enable_managed_prometheus
      }
      advanced_datapath_observability_config {
        enable_metrics = var.monitoring_enable_observability_metrics
        relay_mode     = var.monitoring_observability_metrics_relay_mode
      }
    }
  }
  cluster_autoscaling {
    enabled = var.cluster_autoscaling.enabled
    dynamic "auto_provisioning_defaults" {
      for_each = var.cluster_autoscaling.enabled ? [1] : []

      content {
        service_account = local.service_account
        oauth_scopes    = local.node_pools_oauth_scopes["all"]

        management {
          auto_repair  = lookup(var.cluster_autoscaling, "auto_repair", true)
          auto_upgrade = lookup(var.cluster_autoscaling, "auto_upgrade", true)
        }

        disk_size = lookup(var.cluster_autoscaling, "disk_size", 100)
        disk_type = lookup(var.cluster_autoscaling, "disk_type", "pd-standard")

      }
    }
    autoscaling_profile = var.cluster_autoscaling.autoscaling_profile != null ? var.cluster_autoscaling.autoscaling_profile : "BALANCED"
    dynamic "resource_limits" {
      for_each = local.autoscaling_resource_limits
      content {
        resource_type = lookup(resource_limits.value, "resource_type")
        minimum       = lookup(resource_limits.value, "minimum")
        maximum       = lookup(resource_limits.value, "maximum")
      }
    }
  }
  vertical_pod_autoscaling {
    enabled = var.enable_vertical_pod_autoscaling
  }
  default_max_pods_per_node = var.default_max_pods_per_node
  enable_shielded_nodes     = var.enable_shielded_nodes

  dynamic "binary_authorization" {
    for_each = var.enable_binary_authorization ? [var.enable_binary_authorization] : []
    content {
      evaluation_mode = "PROJECT_SINGLETON_POLICY_ENFORCE"
    }
  }

  enable_kubernetes_alpha = var.enable_kubernetes_alpha
  enable_tpu              = var.enable_tpu
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

    network_policy_config {
      disabled = !var.network_policy
    }

    dns_cache_config {
      enabled = var.dns_cache
    }

    gcp_filestore_csi_driver_config {
      enabled = var.filestore_csi_driver
    }

    dynamic "gce_persistent_disk_csi_driver_config" {
      for_each = local.cluster_gce_pd_csi_config

      content {
        enabled = gce_persistent_disk_csi_driver_config.value.enabled
      }
    }

    dynamic "gke_backup_agent_config" {
      for_each = local.gke_backup_agent_config

      content {
        enabled = gke_backup_agent_config.value.enabled
      }
    }

    dynamic "gcs_fuse_csi_driver_config" {
      for_each = local.gcs_fuse_csi_driver_config

      content {
        enabled = gcs_fuse_csi_driver_config.value.enabled
      }
    }

    config_connector_config {
      enabled = var.config_connector
    }
  }

  datapath_provider = var.datapath_provider


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

  lifecycle {
    ignore_changes = [node_pool, initial_node_count, resource_labels["asmv"]]
  }

  dynamic "dns_config" {
    for_each = var.cluster_dns_provider == "CLOUD_DNS" ? [1] : []
    content {
      cluster_dns        = var.cluster_dns_provider
      cluster_dns_scope  = var.cluster_dns_scope
      cluster_dns_domain = var.cluster_dns_domain
    }
  }

  timeouts {
    create = lookup(var.timeouts, "create", "45m")
    update = lookup(var.timeouts, "update", "45m")
    delete = lookup(var.timeouts, "delete", "45m")
  }
  node_pool {
    name               = "default-pool"
    initial_node_count = var.initial_node_count

    management {
      auto_repair  = lookup(var.cluster_autoscaling, "auto_repair", true)
      auto_upgrade = lookup(var.cluster_autoscaling, "auto_upgrade", true)
    }

    node_config {
      image_type       = lookup(var.node_pools[0], "image_type", "COS_CONTAINERD")
      machine_type     = lookup(var.node_pools[0], "machine_type", "e2-medium")
      min_cpu_platform = lookup(var.node_pools[0], "min_cpu_platform", "")
      dynamic "gcfs_config" {
        for_each = lookup(var.node_pools[0], "enable_gcfs", false) ? [true] : []
        content {
          enabled = gcfs_config.value
        }
      }

      dynamic "gvnic" {
        for_each = lookup(var.node_pools[0], "enable_gvnic", false) ? [true] : []
        content {
          enabled = gvnic.value
        }
      }

      service_account = lookup(var.node_pools[0], "service_account", local.service_account)

      tags = concat(
        lookup(local.node_pools_tags, "default_values", [true, true])[0] ? [local.cluster_network_tag] : [],
        lookup(local.node_pools_tags, "default_values", [true, true])[1] ? ["${local.cluster_network_tag}-default-pool"] : [],
        lookup(local.node_pools_tags, "all", []),
        lookup(local.node_pools_tags, var.node_pools[0].name, []),
      )

      logging_variant = lookup(var.node_pools[0], "logging_variant", "DEFAULT")

      dynamic "workload_metadata_config" {
        for_each = local.cluster_node_metadata_config

        content {
          mode = workload_metadata_config.value.mode
        }
      }

      metadata = local.node_pools_metadata["all"]


      shielded_instance_config {
        enable_secure_boot          = lookup(var.node_pools[0], "enable_secure_boot", false)
        enable_integrity_monitoring = lookup(var.node_pools[0], "enable_integrity_monitoring", true)
      }
    }
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


  remove_default_node_pool = var.remove_default_node_pool

  dynamic "database_encryption" {
    for_each = var.database_encryption

    content {
      key_name = database_encryption.value.key_name
      state    = database_encryption.value.state
    }
  }

  dynamic "workload_identity_config" {
    for_each = local.cluster_workload_identity_config

    content {
      workload_pool = workload_identity_config.value.workload_pool
    }
  }

  dynamic "mesh_certificates" {
    for_each = local.cluster_mesh_certificates_config

    content {
      enable_certificates = mesh_certificates.value.enable_certificates
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
}
/******************************************
  Create Container Cluster node pools
 *****************************************/
resource "google_container_node_pool" "pools" {
  provider = google
  for_each = local.node_pools
  name     = each.key
  project  = var.project_id
  location = local.location
  // use node_locations if provided, defaults to cluster level node_locations if not specified
  node_locations = lookup(each.value, "node_locations", "") != "" ? split(",", each.value["node_locations"]) : null

  cluster = google_container_cluster.primary.name

  version = lookup(each.value, "auto_upgrade", local.default_auto_upgrade) ? "" : lookup(
    each.value,
    "version",
    google_container_cluster.primary.min_master_version,
  )

  initial_node_count = lookup(each.value, "autoscaling", true) ? lookup(
    each.value,
    "initial_node_count",
    lookup(each.value, "min_count", 1)
  ) : null

  max_pods_per_node = lookup(each.value, "max_pods_per_node", null)

  node_count = lookup(each.value, "autoscaling", true) ? null : lookup(each.value, "node_count", 1)

  dynamic "autoscaling" {
    for_each = lookup(each.value, "autoscaling", true) ? [each.value] : []
    content {
      min_node_count       = contains(keys(autoscaling.value), "total_min_count") ? null : lookup(autoscaling.value, "min_count", 1)
      max_node_count       = contains(keys(autoscaling.value), "total_max_count") ? null : lookup(autoscaling.value, "max_count", 100)
      location_policy      = lookup(autoscaling.value, "location_policy", null)
      total_min_node_count = lookup(autoscaling.value, "total_min_count", null)
      total_max_node_count = lookup(autoscaling.value, "total_max_count", null)
    }
  }

  dynamic "placement_policy" {
    for_each = length(lookup(each.value, "placement_policy", "")) > 0 ? [each.value] : []
    content {
      type = lookup(placement_policy.value, "placement_policy", null)
    }
  }

  dynamic "network_config" {
    for_each = length(lookup(each.value, "pod_range", "")) > 0 ? [each.value] : []
    content {
      pod_range            = lookup(network_config.value, "pod_range", null)
      enable_private_nodes = lookup(network_config.value, "enable_private_nodes", null)
    }
  }

  management {
    auto_repair  = lookup(each.value, "auto_repair", true)
    auto_upgrade = lookup(each.value, "auto_upgrade", local.default_auto_upgrade)
  }

  upgrade_settings {
    strategy        = lookup(each.value, "strategy", "SURGE")
    max_surge       = lookup(each.value, "strategy", "SURGE") == "SURGE" ? lookup(each.value, "max_surge", 1) : null
    max_unavailable = lookup(each.value, "strategy", "SURGE") == "SURGE" ? lookup(each.value, "max_unavailable", 0) : null

    dynamic "blue_green_settings" {
      for_each = lookup(each.value, "strategy", "SURGE") == "BLUE_GREEN" ? [1] : []
      content {
        node_pool_soak_duration = lookup(each.value, "node_pool_soak_duration", null)

        standard_rollout_policy {
          batch_soak_duration = lookup(each.value, "batch_soak_duration", null)
          batch_percentage    = lookup(each.value, "batch_percentage", null)
          batch_node_count    = lookup(each.value, "batch_node_count", null)
        }
      }
    }
  }

  node_config {
    image_type       = lookup(each.value, "image_type", "COS_CONTAINERD")
    machine_type     = lookup(each.value, "machine_type", "e2-medium")
    min_cpu_platform = lookup(each.value, "min_cpu_platform", "")
    dynamic "gcfs_config" {
      for_each = lookup(each.value, "enable_gcfs", false) ? [true] : []
      content {
        enabled = gcfs_config.value
      }
    }
    dynamic "gvnic" {
      for_each = lookup(each.value, "enable_gvnic", false) ? [true] : []
      content {
        enabled = gvnic.value
      }
    }
    labels = merge(
      lookup(lookup(local.node_pools_labels, "default_values", {}), "cluster_name", true) ? { "cluster_name" = var.name } : {},
      lookup(lookup(local.node_pools_labels, "default_values", {}), "node_pool", true) ? { "node_pool" = each.value["name"] } : {},
      local.node_pools_labels["all"],
      local.node_pools_labels[each.value["name"]],
    )
    resource_labels = merge(
      local.node_pools_resource_labels["all"],
      local.node_pools_resource_labels[each.value["name"]],
    )
    metadata = merge(
      lookup(lookup(local.node_pools_metadata, "default_values", {}), "cluster_name", true) ? { "cluster_name" = var.name } : {},
      lookup(lookup(local.node_pools_metadata, "default_values", {}), "node_pool", true) ? { "node_pool" = each.value["name"] } : {},
      local.node_pools_metadata["all"],
      local.node_pools_metadata[each.value["name"]],
      {
        "disable-legacy-endpoints" = var.disable_legacy_metadata_endpoints
      },
    )
    dynamic "taint" {
      for_each = concat(
        local.node_pools_taints["all"],
        local.node_pools_taints[each.value["name"]],
      )
      content {
        effect = taint.value.effect
        key    = taint.value.key
        value  = taint.value.value
      }
    }
    tags = concat(
      lookup(local.node_pools_tags, "default_values", [true, true])[0] ? [local.cluster_network_tag] : [],
      lookup(local.node_pools_tags, "default_values", [true, true])[1] ? ["${local.cluster_network_tag}-${each.value["name"]}"] : [],
      local.node_pools_tags["all"],
      local.node_pools_tags[each.value["name"]],
    )

    logging_variant = lookup(each.value, "logging_variant", "DEFAULT")

    local_ssd_count = lookup(each.value, "local_ssd_count", 0)
    disk_size_gb    = lookup(each.value, "disk_size_gb", 100)
    disk_type       = lookup(each.value, "disk_type", "pd-standard")


    service_account = lookup(
      each.value,
      "service_account",
      local.service_account,
    )
    preemptible = lookup(each.value, "preemptible", false)
    spot        = lookup(each.value, "spot", false)

    oauth_scopes = concat(
      local.node_pools_oauth_scopes["all"],
      local.node_pools_oauth_scopes[each.value["name"]],
    )

    dynamic "guest_accelerator" {
      for_each = lookup(each.value, "accelerator_count", 0) > 0 ? [1] : []
      content {
        type               = lookup(each.value, "accelerator_type", "")
        count              = lookup(each.value, "accelerator_count", 0)
        gpu_partition_size = lookup(each.value, "gpu_partition_size", null)

        dynamic "gpu_driver_installation_config" {
          for_each = lookup(each.value, "gpu_driver_version", "") != "" ? [1] : []
          content {
            gpu_driver_version = lookup(each.value, "gpu_driver_version", "")
          }
        }
      }
    }

    dynamic "workload_metadata_config" {
      for_each = local.cluster_node_metadata_config

      content {
        mode = lookup(each.value, "node_metadata", workload_metadata_config.value.mode)
      }
    }


    dynamic "linux_node_config" {
      for_each = length(merge(
        local.node_pools_linux_node_configs_sysctls["all"],
        local.node_pools_linux_node_configs_sysctls[each.value["name"]]
      )) != 0 ? [1] : []

      content {
        sysctls = merge(
          local.node_pools_linux_node_configs_sysctls["all"],
          local.node_pools_linux_node_configs_sysctls[each.value["name"]]
        )
      }
    }

    boot_disk_kms_key = lookup(each.value, "boot_disk_kms_key", "")

    shielded_instance_config {
      enable_secure_boot          = lookup(each.value, "enable_secure_boot", false)
      enable_integrity_monitoring = lookup(each.value, "enable_integrity_monitoring", true)
    }
  }

  lifecycle {
    ignore_changes = [initial_node_count]

  }

  timeouts {
    create = lookup(var.timeouts, "create", "45m")
    update = lookup(var.timeouts, "update", "45m")
    delete = lookup(var.timeouts, "delete", "45m")
  }

}
resource "google_container_node_pool" "windows_pools" {
  provider = google
  for_each = local.windows_node_pools
  name     = each.key
  project  = var.project_id
  location = local.location
  // use node_locations if provided, defaults to cluster level node_locations if not specified
  node_locations = lookup(each.value, "node_locations", "") != "" ? split(",", each.value["node_locations"]) : null

  cluster = google_container_cluster.primary.name

  version = lookup(each.value, "auto_upgrade", local.default_auto_upgrade) ? "" : lookup(
    each.value,
    "version",
    google_container_cluster.primary.min_master_version,
  )

  initial_node_count = lookup(each.value, "autoscaling", true) ? lookup(
    each.value,
    "initial_node_count",
    lookup(each.value, "min_count", 1)
  ) : null

  max_pods_per_node = lookup(each.value, "max_pods_per_node", null)

  node_count = lookup(each.value, "autoscaling", true) ? null : lookup(each.value, "node_count", 1)

  dynamic "autoscaling" {
    for_each = lookup(each.value, "autoscaling", true) ? [each.value] : []
    content {
      min_node_count       = contains(keys(autoscaling.value), "total_min_count") ? null : lookup(autoscaling.value, "min_count", 1)
      max_node_count       = contains(keys(autoscaling.value), "total_max_count") ? null : lookup(autoscaling.value, "max_count", 100)
      location_policy      = lookup(autoscaling.value, "location_policy", null)
      total_min_node_count = lookup(autoscaling.value, "total_min_count", null)
      total_max_node_count = lookup(autoscaling.value, "total_max_count", null)
    }
  }

  dynamic "placement_policy" {
    for_each = length(lookup(each.value, "placement_policy", "")) > 0 ? [each.value] : []
    content {
      type = lookup(placement_policy.value, "placement_policy", null)
    }
  }

  dynamic "network_config" {
    for_each = length(lookup(each.value, "pod_range", "")) > 0 ? [each.value] : []
    content {
      pod_range            = lookup(network_config.value, "pod_range", null)
      enable_private_nodes = lookup(network_config.value, "enable_private_nodes", null)
    }
  }

  management {
    auto_repair  = lookup(each.value, "auto_repair", true)
    auto_upgrade = lookup(each.value, "auto_upgrade", local.default_auto_upgrade)
  }

  upgrade_settings {
    strategy        = lookup(each.value, "strategy", "SURGE")
    max_surge       = lookup(each.value, "strategy", "SURGE") == "SURGE" ? lookup(each.value, "max_surge", 1) : null
    max_unavailable = lookup(each.value, "strategy", "SURGE") == "SURGE" ? lookup(each.value, "max_unavailable", 0) : null

    dynamic "blue_green_settings" {
      for_each = lookup(each.value, "strategy", "SURGE") == "BLUE_GREEN" ? [1] : []
      content {
        node_pool_soak_duration = lookup(each.value, "node_pool_soak_duration", null)

        standard_rollout_policy {
          batch_soak_duration = lookup(each.value, "batch_soak_duration", null)
          batch_percentage    = lookup(each.value, "batch_percentage", null)
          batch_node_count    = lookup(each.value, "batch_node_count", null)
        }
      }
    }
  }

  node_config {
    image_type       = lookup(each.value, "image_type", "COS_CONTAINERD")
    machine_type     = lookup(each.value, "machine_type", "e2-medium")
    min_cpu_platform = lookup(each.value, "min_cpu_platform", "")
    dynamic "gcfs_config" {
      for_each = lookup(each.value, "enable_gcfs", false) ? [true] : []
      content {
        enabled = gcfs_config.value
      }
    }
    dynamic "gvnic" {
      for_each = lookup(each.value, "enable_gvnic", false) ? [true] : []
      content {
        enabled = gvnic.value
      }
    }
    labels = merge(
      lookup(lookup(local.node_pools_labels, "default_values", {}), "cluster_name", true) ? { "cluster_name" = var.name } : {},
      lookup(lookup(local.node_pools_labels, "default_values", {}), "node_pool", true) ? { "node_pool" = each.value["name"] } : {},
      local.node_pools_labels["all"],
      local.node_pools_labels[each.value["name"]],
    )
    resource_labels = merge(
      local.node_pools_resource_labels["all"],
      local.node_pools_resource_labels[each.value["name"]],
    )
    metadata = merge(
      lookup(lookup(local.node_pools_metadata, "default_values", {}), "cluster_name", true) ? { "cluster_name" = var.name } : {},
      lookup(lookup(local.node_pools_metadata, "default_values", {}), "node_pool", true) ? { "node_pool" = each.value["name"] } : {},
      local.node_pools_metadata["all"],
      local.node_pools_metadata[each.value["name"]],
      {
        "disable-legacy-endpoints" = var.disable_legacy_metadata_endpoints
      },
    )
    dynamic "taint" {
      for_each = concat(
        local.node_pools_taints["all"],
        local.node_pools_taints[each.value["name"]],
      )
      content {
        effect = taint.value.effect
        key    = taint.value.key
        value  = taint.value.value
      }
    }
    tags = concat(
      lookup(local.node_pools_tags, "default_values", [true, true])[0] ? [local.cluster_network_tag] : [],
      lookup(local.node_pools_tags, "default_values", [true, true])[1] ? ["${local.cluster_network_tag}-${each.value["name"]}"] : [],
      local.node_pools_tags["all"],
      local.node_pools_tags[each.value["name"]],
    )

    logging_variant = lookup(each.value, "logging_variant", "DEFAULT")

    local_ssd_count = lookup(each.value, "local_ssd_count", 0)
    disk_size_gb    = lookup(each.value, "disk_size_gb", 100)
    disk_type       = lookup(each.value, "disk_type", "pd-standard")


    service_account = lookup(
      each.value,
      "service_account",
      local.service_account,
    )
    preemptible = lookup(each.value, "preemptible", false)
    spot        = lookup(each.value, "spot", false)

    oauth_scopes = concat(
      local.node_pools_oauth_scopes["all"],
      local.node_pools_oauth_scopes[each.value["name"]],
    )

    dynamic "guest_accelerator" {
      for_each = lookup(each.value, "accelerator_count", 0) > 0 ? [1] : []
      content {
        type               = lookup(each.value, "accelerator_type", "")
        count              = lookup(each.value, "accelerator_count", 0)
        gpu_partition_size = lookup(each.value, "gpu_partition_size", null)

        dynamic "gpu_driver_installation_config" {
          for_each = lookup(each.value, "gpu_driver_version", "") != "" ? [1] : []
          content {
            gpu_driver_version = lookup(each.value, "gpu_driver_version", "")
          }
        }
      }
    }

    dynamic "workload_metadata_config" {
      for_each = local.cluster_node_metadata_config

      content {
        mode = lookup(each.value, "node_metadata", workload_metadata_config.value.mode)
      }
    }



    boot_disk_kms_key = lookup(each.value, "boot_disk_kms_key", "")

    shielded_instance_config {
      enable_secure_boot          = lookup(each.value, "enable_secure_boot", false)
      enable_integrity_monitoring = lookup(each.value, "enable_integrity_monitoring", true)
    }
  }

  lifecycle {
    ignore_changes = [initial_node_count]

  }

  timeouts {
    create = lookup(var.timeouts, "create", "45m")
    update = lookup(var.timeouts, "update", "45m")
    delete = lookup(var.timeouts, "delete", "45m")
  }

  depends_on = [google_container_node_pool.pools[0]]
}




# Setup dynamic default values for variables which can't be setup using
# the standard terraform "variable default" functionality

locals {
  node_pools_labels = merge(
    { all = {} },
    { default-node-pool = {} },
    zipmap(
      [for node_pool in var.node_pools : node_pool["name"]],
      [for node_pool in var.node_pools : {}]
    ),
    zipmap(
      [for node_pool in var.windows_node_pools : node_pool["name"]],
      [for node_pool in var.windows_node_pools : {}]
    ),
    var.node_pools_labels
  )

  node_pools_resource_labels = merge(
    { all = {} },
    { default-node-pool = {} },
    zipmap(
      [for node_pool in var.node_pools : node_pool["name"]],
      [for node_pool in var.node_pools : {}]
    ),
    zipmap(
      [for node_pool in var.windows_node_pools : node_pool["name"]],
      [for node_pool in var.windows_node_pools : {}]
    ),
    var.node_pools_resource_labels
  )

  node_pools_metadata = merge(
    { all = {} },
    { default-node-pool = {} },
    zipmap(
      [for node_pool in var.node_pools : node_pool["name"]],
      [for node_pool in var.node_pools : {}]
    ),
    zipmap(
      [for node_pool in var.windows_node_pools : node_pool["name"]],
      [for node_pool in var.windows_node_pools : {}]
    ),
    var.node_pools_metadata
  )

  node_pools_taints = merge(
    { all = [] },
    { default-node-pool = [] },
    zipmap(
      [for node_pool in var.node_pools : node_pool["name"]],
      [for node_pool in var.node_pools : []]
    ),
    zipmap(
      [for node_pool in var.windows_node_pools : node_pool["name"]],
      [for node_pool in var.windows_node_pools : []]
    ),
    var.node_pools_taints
  )

  node_pools_tags = merge(
    { all = [] },
    { default-node-pool = [] },
    zipmap(
      [for node_pool in var.node_pools : node_pool["name"]],
      [for node_pool in var.node_pools : []]
    ),
    zipmap(
      [for node_pool in var.windows_node_pools : node_pool["name"]],
      [for node_pool in var.windows_node_pools : []]
    ),
    var.node_pools_tags
  )

  node_pools_oauth_scopes = merge(
    { all = ["https://www.googleapis.com/auth/cloud-platform"] },
    { default-node-pool = [] },
    zipmap(
      [for node_pool in var.node_pools : node_pool["name"]],
      [for node_pool in var.node_pools : []]
    ),
    zipmap(
      [for node_pool in var.windows_node_pools : node_pool["name"]],
      [for node_pool in var.windows_node_pools : []]
    ),
    var.node_pools_oauth_scopes
  )

  node_pools_linux_node_configs_sysctls = merge(
    { all = {} },
    { default-node-pool = {} },
    zipmap(
      [for node_pool in var.node_pools : node_pool["name"]],
      [for node_pool in var.node_pools : {}]
    ),
    var.node_pools_linux_node_configs_sysctls
  )
}




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
    google_container_node_pool.pools,
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
    google_container_node_pool.pools,
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
    google_container_node_pool.pools,
  ]
}
