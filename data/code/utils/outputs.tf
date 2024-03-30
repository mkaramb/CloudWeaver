
output "region_short_name_map" {
  description = "The 4 or 5 character shortname of any given region."
  value       = local.region_short_name_map
}

output "region_short_name" {
  description = "The 4 or 5 character shortname of the region specified in var.region."
  value       = local.region_short_name
}
