
variable "host_project_id" {
  description = "Id of the host project where the shared VPC will be created."
}

variable "service_project_id" {
  description = "Service project id."
}

variable "service_project_number" {
  description = "Service project number."
}

variable "service_project_owners" {
  description = "Service project owners, in IAM format."
  default     = []
}

variable "network_name" {
  description = "Name of the shared VPC."
  default     = "test-svpc"
}
