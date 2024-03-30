
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
  pubsub_topic_iam_binding variables
 *****************************************/
variable "pubsub_topic_project" {
  type        = string
  description = "Project id of the pub/sub topic"
}

variable "pubsub_topic_one" {
  type        = string
  description = "First pubsub topic to add the IAM policies/bindings"
}

variable "pubsub_topic_two" {
  type        = string
  description = "Second pubsub topic to add the IAM policies/bindings"
}

