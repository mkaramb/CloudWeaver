
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
  default     = "hello-world-container-vm"
}

variable "zone" {
  description = "The GCP zone to deploy instances into"
  type        = string
}

variable "additional_metadata" {
  type        = map(string)
  description = "Additional metadata to attach to the instance"
  default     = {}
}

variable "client_email" {
  description = "Service account email address"
  type        = string
  default     = ""
}

variable "cos_image_name" {
  description = "The forced COS image to use instead of latest"
  default     = "cos-stable-77-12371-89-0"
}
