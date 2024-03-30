
variable "project_id" {
  type        = string
  description = "The project to run tests against"
}

variable "pg_psc_name" {
  type        = string
  description = "The name for Cloud SQL instance"
  default     = "tf-pg-psc"
}
