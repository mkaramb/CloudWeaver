
output "folder" {
  description = "Folder resource (for single use)."
  value       = try(local.first_folder, "")
}

output "id" {
  description = "Folder id (for single use)."
  value       = try(local.first_folder.name, "")
}

output "name" {
  description = "Folder name (for single use)."
  value       = try(local.first_folder.display_name, "")
}

output "folders" {
  description = "Folder resources as list."
  value       = try(local.folders_list, [])
}

output "folders_map" {
  description = "Folder resources by name."
  value       = google_folder.folders
}

output "ids" {
  description = "Folder ids."
  value       = { for name in var.names : name => try(google_folder.folders[name].name, "") }
}

output "names" {
  description = "Folder names."
  value = { for name, folder in google_folder.folders :
    name => folder.display_name
  }
}

output "ids_list" {
  description = "List of folder ids."
  value       = try(local.folders_list[*].name, [])
}

output "names_list" {
  description = "List of folder names."
  value       = try(local.folders_list[*].display_name, [])
}

output "per_folder_admins" {
  description = "IAM-style members per folder who will get extended permissions."
  # value       = var.per_folder_admins
  value = { for k, v in var.per_folder_admins : k => join(",", v.members) }
}

