
variable "project_id" {
  type        = string
  description = "The project to run tests against"
}

variable "sql_server_audit_config" {
  description = "SQL server audit config settings."
  type        = map(string)
  default     = {}
}

variable "network_name" {
  description = "The ID of the network in which to provision resources."
  type        = string
  default     = "test-mssql-failover"
}
