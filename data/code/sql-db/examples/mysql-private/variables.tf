
variable "project_id" {
  type        = string
  description = "The project to run tests against"
}

variable "network_name" {
  default = "mysql-private"
  type    = string
}

variable "db_name" {
  description = "The name of the SQL Database instance"
  default     = "example-mysql-private"
}

variable "cloudsql_mysql_sa" {
  type        = string
  description = "IAM service account user created for Cloud SQL."
}
