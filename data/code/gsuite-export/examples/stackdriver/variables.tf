
variable "service_account" {
  description = "The service account for exporting GSuite data. Needs domain-wide delegation and correct access scopes."
  type        = string
}

variable "project_id" {
  description = "The project to export GSuite data to."
  type        = string
}
