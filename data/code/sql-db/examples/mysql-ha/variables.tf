
variable "project_id" {
  type        = string
  description = "The project to run tests against"
}

variable "mysql_ha_name" {
  type        = string
  description = "The name for Cloud SQL instance"
  default     = "tf-mysql-ha"
}

variable "mysql_ha_external_ip_range" {
  type        = string
  description = "The ip range to allow connecting from/to Cloud SQL"
  default     = "192.10.10.10/32"
}
