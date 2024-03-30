
output "added_udfs" {
  description = "List of UDFs utility functions added."
  value       = var.add_udfs ? ["find_in_set", "check_protocol", "parse_url", "csv_to_struct"] : []
}
