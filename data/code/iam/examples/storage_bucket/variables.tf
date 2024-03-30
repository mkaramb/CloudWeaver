
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
  storage_bucket_iam_binding variables
 *****************************************/
variable "storage_bucket_one" {
  type        = string
  description = "First name of a GCS bucket to add the IAM policies/bindings"
}

variable "storage_bucket_two" {
  type        = string
  description = "Second name of a GCS bucket to add the IAM policies/bindings"
}

