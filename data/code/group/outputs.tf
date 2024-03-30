
output "id" {
  value       = google_cloud_identity_group.group.group_key[0].id
  description = "ID of the group. For Google-managed entities, the ID is the email address the group"
}

output "name" {
  value       = split("@", google_cloud_identity_group.group.group_key[0].id)[0]
  description = "Name of the group with the domain removed. For Google-managed entities, the ID is the email address the group"
}

output "resource_name" {
  value       = google_cloud_identity_group.group.name
  description = "Resource name of the group in the format: groups/{group_id}, where group_id is the unique ID assigned to the group."
}
