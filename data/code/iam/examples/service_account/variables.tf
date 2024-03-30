
variable "group_email" {
  type        = string
  description = "Email for group to receive roles (ex. group@example.com)"
  default     = "goose_net_admins@goosecorp.org"
}

variable "sa_email" {
  type        = string
  description = "Email for Service Account to receive roles (Ex. default-sa@example-project-id.iam.gserviceaccount.com)"
  default     = "sa-tf-test-receiver-01@ci-iam-0c5f.iam.gserviceaccount.com"
}

variable "user_email" {
  type        = string
  description = "Email for group to receive roles (Ex. user@example.com)"
  default     = "awmalik@google.com"

}

/******************************************
  service_account_iam_binding variables
 *****************************************/
variable "service_account_project" {
  type        = string
  description = "Project id of the service account"
  default     = "ci-iam-0c5f"
}

variable "service_account_one" {
  type        = string
  description = "First service Account to add the IAM policies/bindings"
  default     = "sa-tf-test-01@ci-iam-0c5f.iam.gserviceaccount.com"
}

variable "service_account_two" {
  type        = string
  description = "First service Account to add the IAM policies/bindings"
  default     = "sa-tf-test-02@ci-iam-0c5f.iam.gserviceaccount.com"
}
