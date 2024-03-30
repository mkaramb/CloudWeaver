
variable "project" {
  description = "Project to add the IAM policies/bindings"
  type        = string
}

variable "bigquery_datasets" {
  description = "BigQuery dataset IDs list to add the IAM policies/bindings"
  type        = list(string)
}

variable "mode" {
  description = "Mode for adding the IAM policies/bindings, additive and authoritative"
  type        = string
  default     = "additive"
}

variable "bindings" {
  description = "Map of role (key) and list of members (value) to add the IAM policies/bindings"
  type        = map(any)
}
