
locals {
  prefix       = var.prefix == "" ? "" : "${var.prefix}-"
  folders_list = [for name in var.names : try(google_folder.folders[name], "")]
  first_folder = try(local.folders_list[0], {})
  folder_admin_roles_map_data = merge([
    for name, config in var.per_folder_admins : {
      for role in config.roles != null ? config.roles : var.folder_admin_roles : "${name}-${role}" =>
      {
        name    = name,
        role    = role,
        members = config.members,
      }
    }
  ]...)
}

resource "google_folder" "folders" {
  for_each = toset(var.names)

  display_name = "${local.prefix}${each.value}"
  parent       = var.parent
}

# give project creation access to service accounts
# https://cloud.google.com/resource-manager/docs/access-control-folders#granting_folder-specific_roles_to_enable_project_creation

resource "google_folder_iam_binding" "owners" {
  for_each = var.set_roles ? local.folder_admin_roles_map_data : {}
  folder   = google_folder.folders[each.value.name].name
  role     = each.value.role

  members = concat(
    each.value.members,
    var.all_folder_admins,
  )
}
