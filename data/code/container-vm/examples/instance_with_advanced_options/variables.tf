
variable "project_id" {
  description = "The project ID to deploy resources into"
}

variable "subnetwork_project" {
  description = "The project ID where the desired subnetwork is provisioned"
}

variable "subnetwork" {
  description = "The name of the subnetwork to deploy instances into"
}

variable "instance_name" {
  description = "The desired name to assign to the deployed instance"
  default     = "container-vm-advanced-options"
}

variable "zone" {
  description = "The GCP zone to deploy instances into"
  type        = string
}

variable "client_email" {
  description = "Service account email address"
  type        = string
  default     = ""
}
