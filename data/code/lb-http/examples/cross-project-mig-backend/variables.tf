
variable "region" {
  default = "us-central1"
}

variable "project_id" {
  description = "ID for the Shared VPC host project"
}

variable "project_id_1" {
  description = "ID for the Shared VPC service project where instances will be deployed"
}

variable "network_name" {
  type    = string
  default = "multi-mig-cross-project-mig"
}
