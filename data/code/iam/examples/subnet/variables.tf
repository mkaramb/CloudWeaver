
variable "project" {
  type        = string
  description = "The project where the subnet resides"
}

variable "region" {
  type        = string
  description = "The region where the subnet resides"
}

variable "group_email" {
  type        = string
  description = "Email for group to receive roles (ex. group@example.com)"
}

variable "sa_email" {
  type        = string
  description = "Email for Service Account to receive roles (Ex. default-sa@example-project-id.iam.gserviceaccount.com)"
}

variable "user_email" {
  type        = string
  description = "Email for group to receive roles (Ex. user@example.com)"
}

/******************************************
  Subnet_iam_binding variables
 *****************************************/
variable "subnet_one" {
  type        = string
  description = "First subnet id to add the IAM policies/bindings"
}

variable "subnet_two" {
  type        = string
  description = "Second subnet id to add the IAM policies/bindings"
}

