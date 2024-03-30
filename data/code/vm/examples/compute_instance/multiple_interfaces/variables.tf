
variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "subnet_1" {
  description = "Self link to a subnetwork in the same region as the VM."
  type        = string
}

variable "subnet_2" {
  description = "Self link to a subnetwork in the same region as the VM."
  type        = string
}
