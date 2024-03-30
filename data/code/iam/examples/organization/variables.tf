
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
  organization_iam_binding variables
 *****************************************/
variable "organization_one" {
  type        = string
  description = "First organization to add the IAM policies/bindings"
}

variable "organization_two" {
  type        = string
  description = "Second organization to add the IAM policies/bindings"
}

