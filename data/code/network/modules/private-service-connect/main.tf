
locals {
  dns_code        = var.dns_code != "" ? "${var.dns_code}-" : ""
  googleapis_url  = var.forwarding_rule_target == "vpc-sc" ? "restricted.googleapis.com." : "private.googleapis.com."
  recordsets_name = split(".", local.googleapis_url)[0]
}

resource "google_compute_global_address" "private_service_connect" {
  provider     = google-beta
  project      = var.project_id
  name         = var.private_service_connect_name
  address_type = "INTERNAL"
  purpose      = "PRIVATE_SERVICE_CONNECT"
  network      = var.network_self_link
  address      = var.private_service_connect_ip
}

resource "google_compute_global_forwarding_rule" "forwarding_rule_private_service_connect" {
  provider              = google-beta
  project               = var.project_id
  name                  = var.forwarding_rule_name
  target                = var.forwarding_rule_target
  network               = var.network_self_link
  ip_address            = google_compute_global_address.private_service_connect.id
  load_balancing_scheme = ""

  dynamic "service_directory_registrations" {
    for_each = var.service_directory_namespace != null || var.service_directory_region != null ? [1] : []

    content {
      namespace                = var.service_directory_namespace
      service_directory_region = var.service_directory_region
    }
  }
}



/******************************************
  Private Google APIs DNS Zone & records.
 *****************************************/

module "googleapis" {
  source      = "terraform-google-modules/cloud-dns/google"
  version     = "~> 5.0"
  project_id  = var.project_id
  type        = "private"
  name        = "${local.dns_code}apis"
  domain      = "googleapis.com."
  description = "Private DNS zone to configure ${local.googleapis_url}"

  private_visibility_config_networks = [
    var.network_self_link
  ]

  recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = [local.googleapis_url]
    },
    {
      name    = local.recordsets_name
      type    = "A"
      ttl     = 300
      records = [var.private_service_connect_ip]
    },
  ]
}

/******************************************
  GCR DNS Zone & records.
 *****************************************/

module "gcr" {
  source      = "terraform-google-modules/cloud-dns/google"
  version     = "~> 5.0"
  project_id  = var.project_id
  type        = "private"
  name        = "${local.dns_code}gcr"
  domain      = "gcr.io."
  description = "Private DNS zone to configure gcr.io"

  private_visibility_config_networks = [
    var.network_self_link
  ]

  recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["gcr.io."]
    },
    {
      name    = ""
      type    = "A"
      ttl     = 300
      records = [var.private_service_connect_ip]
    },
  ]
}

/***********************************************
  Artifact Registry DNS Zone & records.
 ***********************************************/

module "pkg_dev" {
  source      = "terraform-google-modules/cloud-dns/google"
  version     = "~> 5.0"
  project_id  = var.project_id
  type        = "private"
  name        = "${local.dns_code}pkg-dev"
  domain      = "pkg.dev."
  description = "Private DNS zone to configure pkg.dev"

  private_visibility_config_networks = [
    var.network_self_link
  ]

  recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["pkg.dev."]
    },
    {
      name    = ""
      type    = "A"
      ttl     = 300
      records = [var.private_service_connect_ip]
    },
  ]
}
