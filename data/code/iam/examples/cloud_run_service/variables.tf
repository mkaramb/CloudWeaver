
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
  cloud_run_service_iam_binding variables
 *****************************************/
variable "cloud_run_service_project" {
  type        = string
  description = "Project id of the cloud run service"
}

variable "cloud_run_service_location" {
  type        = string
  description = "The location of the cloud run instance"
}

variable "cloud_run_service_one" {
  type        = string
  description = "First cloud run service to add the IAM policies/bindings"
}

variable "cloud_run_service_two" {
  type        = string
  description = "Second cloud run service to add the IAM policies/bindings"
}

