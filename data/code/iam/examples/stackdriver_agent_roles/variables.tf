
variable "service_account_email" {
  type        = string
  description = "The service account email to enable Stackdriver agent roles on"
}

variable "project" {
  type        = string
  description = "GCP project in which you wish to grant roles to the service account"
}

