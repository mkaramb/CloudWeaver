
variable "region" {
  description = "Region for cloud resources."
  type        = string
}

variable "network" {
  description = "Name of the network to create resources in."
  type        = string
}

variable "subnetwork" {
  description = "Name of the subnetwork to create resources in."
  type        = string
}

variable "service_account" {
  description = "Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template#service_account"
  type = object({
    email  = string
    scopes = set(string)
  })
}

variable "subnetwork_project" {
  description = "Name of the project for the subnetwork. Useful for shared VPC."
  type        = string
}

variable "project" {
  description = "The project id to deploy to"
  type        = string
}
