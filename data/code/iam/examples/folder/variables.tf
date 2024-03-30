
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
  folder_iam_binding variables
 *****************************************/
variable "folder_one" {
  type        = string
  description = "The first folder ID to apply IAM bindings"
}

variable "folder_two" {
  type        = string
  description = "The second folder ID to apply IAM bindings"
}
