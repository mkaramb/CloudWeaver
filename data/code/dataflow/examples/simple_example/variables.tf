
variable "project_id" {
  type        = string
  description = "The project ID to deploy to"
}

variable "region" {
  type        = string
  description = "The region in which the bucket will be deployed"
}

variable "zone" {
  type        = string
  description = "The zone in which the dataflow job will be deployed"
}

variable "service_account_email" {
  type        = string
  description = "The Service Account email used to create the job."
}

variable "force_destroy" {
  type        = bool
  description = "When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run."
  default     = false
}

