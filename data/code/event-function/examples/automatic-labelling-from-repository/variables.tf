
variable "project_id" {
  type        = string
  description = "The ID of the project to which resources will be applied."
}

variable "region" {
  type        = string
  description = "The region in which resources will be applied."
}

variable "zone" {
  type        = string
  description = "The zone in which resources will be applied."
}

variable "subnetwork" {
  type        = string
  description = "The name or self_link of the subnetwork to create compute instance in."
  default     = "default"
}
