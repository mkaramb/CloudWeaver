
variable "project_id" {
  description = "Project ID where Cloud Composer Environment is created."
  type        = string
}

variable "composer_env_name" {
  description = "Name of Cloud Composer Environment"
  type        = string
}

variable "region" {
  description = "Region where the Cloud Composer Environment is created."
  type        = string
}

variable "zone" {
  description = "Zone where the Cloud Composer Environment is created."
  type        = string
}

variable "network" {
  description = "Network where Cloud Composer is created."
  type        = string
}

variable "subnetwork" {
  description = "Subetwork where Cloud Composer is created."
  type        = string
}

variable "enable_private_endpoint" {
  description = "Configure public access to the cluster endpoint."
  type        = bool
  default     = false
}
