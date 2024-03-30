
output "ids" {
  description = "Folder ids."
  value       = module.folders.ids
}

output "names" {
  description = "Folder names."
  value       = module.folders.names
}

output "ids_list" {
  description = "List of folder ids."
  value       = module.folders.ids_list
}

output "names_list" {
  description = "List of folder names."
  value       = module.folders.names_list
}

output "per_folder_admins" {
  description = "IAM-style members per folder who will get extended permissions."
  value       = module.folders.per_folder_admins
}
