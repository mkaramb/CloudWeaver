
locals {
  excluded_permissions = concat(data.google_iam_testable_permissions.unsupported_permissions.permissions[*].name, var.excluded_permissions)
  included_permissions = concat(flatten(values(data.google_iam_role.role_permissions)[*].included_permissions), var.permissions)
  permissions          = [for permission in local.included_permissions : permission if !contains(local.excluded_permissions, permission)]
  custom-role-output   = (var.target_level == "project") ? google_project_iam_custom_role.project-custom-role[0].role_id : google_organization_iam_custom_role.org-custom-role[0].role_id
}

/******************************************
  Permissions from predefined roles
 *****************************************/
data "google_iam_role" "role_permissions" {
  for_each = toset(var.base_roles)
  name     = each.value
}

/******************************************
  Permissions unsupported for custom roles
 *****************************************/
data "google_iam_testable_permissions" "unsupported_permissions" {
  full_resource_name   = var.target_level == "org" ? "//cloudresourcemanager.googleapis.com/organizations/${var.target_id}" : "//cloudresourcemanager.googleapis.com/projects/${var.target_id}"
  stages               = ["GA", "ALPHA", "BETA"]
  custom_support_level = "NOT_SUPPORTED"
}

/******************************************
  Custom IAM Org Role
 *****************************************/
resource "google_organization_iam_custom_role" "org-custom-role" {
  count = var.target_level == "org" ? 1 : 0

  org_id      = var.target_id
  role_id     = var.role_id
  title       = var.title == "" ? var.role_id : var.title
  description = var.description
  permissions = local.permissions
  stage       = var.stage
}

/******************************************
  Assigning custom_role to member
 *****************************************/
resource "google_organization_iam_member" "custom_role_member" {

  for_each = var.target_level == "org" ? toset(var.members) : []
  org_id   = var.target_id
  role     = "organizations/${var.target_id}/roles/${local.custom-role-output}"
  member   = each.key
}

/******************************************
  Custom IAM Project Role
 *****************************************/
resource "google_project_iam_custom_role" "project-custom-role" {
  count = var.target_level == "project" ? 1 : 0

  project     = var.target_id
  role_id     = var.role_id
  title       = var.title == "" ? var.role_id : var.title
  description = var.description
  permissions = local.permissions
  stage       = var.stage
}

/******************************************
  Assigning custom_role to member
 *****************************************/
resource "google_project_iam_member" "custom_role_member" {

  for_each = var.target_level == "project" ? toset(var.members) : []
  project  = var.target_id
  role     = "projects/${var.target_id}/roles/${local.custom-role-output}"
  member   = each.key
}
