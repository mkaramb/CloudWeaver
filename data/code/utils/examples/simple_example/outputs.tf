
output "region_short_name_map" {
  description = "The 4 or 5 character shortname of any given region."
  value       = module.utils.region_short_name_map
}

output "region_short_name" {
  description = "The 4 or 5 character shortname of a given region."
  value       = module.utils.region_short_name
}
