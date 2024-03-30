
variable "service_project_id" {
  description = "Project ID where Cloud Composer Environment is created."
  type        = string
}

variable "project_id" {
  type        = string
  description = "The project ID of the shared VPC's host (for shared vpc support)"
}

variable "network" {
  type        = string
  description = "The name of the network being created"
}

