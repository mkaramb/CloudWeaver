
variable "project_id" {
  type        = string
  description = "The project ID to deploy to"
}

variable "region" {
  type        = string
  description = "The region in which the bucket and the dataflow job will be deployed"
  default     = "us-central1"
}

variable "service_account_email" {
  type        = string
  description = "The Service Account email used to create the job."
}

variable "terraform_service_account_email" {
  type        = string
  description = "The Service Account email used by terraform to spin up resources- the one from environmental variable GOOGLE_APPLICATION_CREDENTIALS"
}

variable "key_ring" {
  type        = string
  description = "The GCP KMS key ring to be created"
}

variable "kms_key_name" {
  type        = string
  description = "The GCP KMS key to be created going under the key ring"
}

variable "wrapped_key" {
  type        = string
  description = "Wrapped key from KMS leave blank if create_key_ring=true"
  default     = ""
}

variable "create_key_ring" {
  type        = bool
  description = "Boolean for determining whether to create key ring with keys(true or false)"
  default     = true
}

