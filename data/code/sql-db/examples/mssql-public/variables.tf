
variable "project_id" {
  type        = string
  description = "The project to run tests against"
}

variable "name" {
  type        = string
  description = "The name for Cloud SQL instance"
  default     = "tf-mssql-public"
}

variable "sql_server_audit_config" {
  description = "SQL server audit config settings."
  type        = map(string)
  default     = {}
}
