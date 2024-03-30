
variable "project_id" {
  type        = string
  description = "Project ID where Cloud Composer Environment is created."
}

variable "region" {
  type        = string
  description = "Region where the Cloud Composer Environment is created."
}

variable "composer_env_name" {
  type        = string
  description = "Name of the Cloud Composer Environment."
}

variable "pool_name" {
  type        = string
  description = "The name of the pool"
}

variable "slot_count" {
  type        = number
  description = "The number of slots in this pool"
}

variable "description" {
  type        = string
  description = "The description of the pool"
  default     = "Managed by Terraform"
}
