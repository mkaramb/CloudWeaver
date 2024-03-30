
variable "project" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "network" {
  description = "Self link for the VPC network"
  type        = string
}

variable "subnet" {
  description = "Self link for the Subnet within var.network"
  type        = string
}

variable "user_a" {
  description = "User in the IAM policy format of user:{email}"
}

variable "user_b" {
  description = "User in the IAM policy format of user:{email}"
}

variable "zone" {
  default = "us-west1-a"
}
