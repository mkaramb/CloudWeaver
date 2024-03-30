
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
  pubsub_subscription_iam_binding variables
 *****************************************/
variable "pubsub_subscription_project" {
  type        = string
  description = "Project id of the pub/sub subscription"
}

variable "pubsub_subscription_one" {
  type        = string
  description = "First pubsub subscription name to add the IAM policies/bindings"
}

variable "pubsub_subscription_two" {
  type        = string
  description = "Second pubsub subscription name to add the IAM policies/bindings"
}

