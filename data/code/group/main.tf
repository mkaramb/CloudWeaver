
data "google_organization" "org" {
  count  = var.domain != "" ? 1 : 0
  domain = var.domain
}

locals {
  customer_id = var.domain != "" ? data.google_organization.org[0].directory_customer_id : var.customer_id
  label_keys = {
    "default"  = "cloudidentity.googleapis.com/groups.discussion_forum"
    "dynamic"  = "cloudidentity.googleapis.com/groups.dynamic"
    "security" = "cloudidentity.googleapis.com/groups.security"
    "external" = "system/groups/external"
    # Placeholders according to https://cloud.google.com/identity/docs/groups#group_properties.
    # Not supported by provider yet.
    "posix" = "cloudidentity.googleapis.com/groups.posix"
  }
}

resource "google_cloud_identity_group" "group" {
  provider     = google-beta
  display_name = var.display_name
  description  = var.description

  parent = "customers/${local.customer_id}"

  initial_group_config = var.initial_group_config

  group_key {
    id = var.id
  }

  labels = { for t in var.types : local.label_keys[t] => "" }
}

resource "google_cloud_identity_group_membership" "owners" {
  for_each = toset(var.owners)

  provider = google-beta
  group    = google_cloud_identity_group.group.id

  preferred_member_key { id = each.key }

  # MEMBER role must be specified. The order of roles should not be changed.
  roles { name = "OWNER" }
  roles { name = "MEMBER" }
}

resource "google_cloud_identity_group_membership" "managers" {
  for_each = toset(var.managers)

  provider = google-beta
  group    = google_cloud_identity_group.group.id

  preferred_member_key { id = each.key }

  # MEMBER role must be specified. The order of roles should not be changed.
  roles { name = "MEMBER" }
  roles { name = "MANAGER" }
}

resource "google_cloud_identity_group_membership" "members" {
  for_each = toset(var.members)

  provider = google-beta
  group    = google_cloud_identity_group.group.id

  preferred_member_key { id = each.key }
  roles { name = "MEMBER" }
}
