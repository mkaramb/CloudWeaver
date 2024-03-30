
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
  project_iam_binding variables
 *****************************************/
variable "project_one" {
  type        = string
  description = "First project id to add the IAM policies/bindings"
}

variable "project_two" {
  type        = string
  description = "Second project id to add the IAM policies/bindings"
}

