variable "prod_project_id" {
  type        = string
  description = "The ID of the production project where the VPC will be created."
}

variable "prod_network" {
  type        = string
  default     = "default"
  description = "The name of the production VPC to be created."
}

variable "mgt_project_id" {
  type        = string
  description = "The ID of the management project where the VPC will be created."
}

variable "mgt_network" {
  type        = string
  default     = "default"
  description = "The name of the management VPC to be created."
}

