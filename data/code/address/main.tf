
/******************************************
  Locals configuration and validation
 *****************************************/
locals {
  dns_fqdns                = formatlist("%s.%s", var.dns_short_names, var.dns_domain)
  regional_addresses_count = var.global ? 0 : length(var.names)
  global_addresses_count   = var.global ? length(var.names) : 0
  dns_forward_record_count = var.enable_cloud_dns ? length(local.dns_fqdns) : 0
  dns_reverse_record_count = var.enable_reverse_dns ? length(local.dns_fqdns) : 0
  ip_addresses = concat(
    google_compute_address.ip[*].address,
    google_compute_global_address.global_ip[*].address,
  )
  ip_names = concat(
    google_compute_address.ip[*].name,
    google_compute_global_address.global_ip[*].name,
  )
  self_links = concat(
    google_compute_address.ip[*].self_link,
    google_compute_global_address.global_ip[*].self_link,
  )
  prefix_length = var.address_type == "EXTERNAL" || (var.address_type == "INTERNAL" && var.purpose == "PRIVATE_SERVICE_CONNECT") ? null : var.prefix_length

  /******************************************
  Format reverse DNS entries - see https://github.com/hashicorp/terraform/issues/9404
  *****************************************/
  split_ips     = [for ip in local.ip_addresses : split(".", ip)]
  dns_ptr_fqdns = var.enable_reverse_dns ? [for split_ip in local.split_ips : "${split_ip[3]}.${split_ip[2]}.${split_ip[1]}.${split_ip[0]}.in-addr.arpa"] : []
}

/******************************************
  IP address reservation
 *****************************************/
resource "google_compute_address" "ip" {
  count        = local.regional_addresses_count
  project      = var.project_id
  region       = var.region
  name         = element(var.names, count.index)
  address      = element(var.addresses, count.index)
  subnetwork   = var.subnetwork
  address_type = var.address_type
  purpose      = var.address_type == "INTERNAL" ? var.purpose : null
  network_tier = var.address_type == "INTERNAL" ? null : var.network_tier
}

resource "google_compute_global_address" "global_ip" {
  count         = local.global_addresses_count
  project       = var.project_id
  name          = var.names[count.index]
  address_type  = var.address_type
  address       = element(var.addresses, count.index)
  network       = var.address_type == "EXTERNAL" ? null : var.subnetwork
  purpose       = var.global && var.address_type == "INTERNAL" ? "VPC_PEERING" : null
  prefix_length = local.prefix_length
  ip_version    = var.ip_version
}

/******************************************
  Forward and reverse DNS entries - note the trailing dot in name
 *****************************************/
resource "google_dns_record_set" "ip" {
  count        = local.dns_forward_record_count
  name         = "${local.dns_fqdns[count.index]}."
  managed_zone = var.dns_managed_zone
  type         = var.dns_record_type
  ttl          = var.dns_ttl
  rrdatas      = length(local.ip_addresses) == 1 ? [local.ip_addresses[0]] : [local.ip_addresses[count.index]]
  project      = var.dns_project
}

resource "google_dns_record_set" "ptr" {
  count        = local.dns_reverse_record_count
  name         = "${local.dns_ptr_fqdns[count.index]}."
  managed_zone = var.dns_reverse_zone
  type         = "PTR"
  ttl          = var.dns_ttl
  rrdatas      = ["${local.dns_fqdns[count.index]}."]
  project      = var.dns_project
}

