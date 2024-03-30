
variable "project_id" {
  type        = string
  description = "GCP Project ID."
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
  secret_iam_binding variables
 *****************************************/
variable "secret_one" {
  type        = string
  description = "The first secret ID to apply IAM bindings"
}

variable "secret_two" {
  type        = string
  description = "The second secret ID to apply IAM bindings"
}
