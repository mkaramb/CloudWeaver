
variable "project_id" {
  description = "The project to create test resources within."
  type        = string
}

variable "region" {
  description = "Region for cloud resources."
  type        = string
  default     = "us-central1"
}
