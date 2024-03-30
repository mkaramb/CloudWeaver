
variable "project_id" {
  description = "The ID of the project in which the log export will be created."
  type        = string
}

variable "parent_resource_id" {
  description = "The ID of the project in which BigQuery dataset destination will be created."
  type        = string
}

variable "bigquery_options" {
  default     = null
  description = "(Optional) Options that affect sinks exporting data to BigQuery. use_partitioned_tables - (Required) Whether to use BigQuery's partition tables."
  type = object({
    use_partitioned_tables = bool
  })
}
