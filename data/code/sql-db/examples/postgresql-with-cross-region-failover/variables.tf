
variable "project_id" {
  type        = string
  description = "The project to run tests against"
}

variable "pg_name_1" {
  type        = string
  description = "The name for Cloud SQL instance"
  default     = "tf-pg-x-1"
}

variable "pg_name_2" {
  type        = string
  description = "The name for Cloud SQL instance"
  default     = "tf-pg-x-2"
}

variable "pg_ha_external_ip_range" {
  type        = string
  description = "The ip range to allow connecting from/to Cloud SQL"
  default     = "192.10.10.10/32"
}

variable "network_name" {
  description = "The ID of the network in which to provision resources."
  type        = string
  default     = "test-postgres-failover"
}
