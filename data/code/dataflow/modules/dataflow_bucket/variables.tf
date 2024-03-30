
variable "project_id" {
  type        = string
  description = "The project_id to deploy the example instance into.  (e.g. \"simple-sample-project-1234\")"
}

variable "region" {
  type        = string
  description = "The GCS bucket region. This should be the same as your dataflow job's zone ot optimize performance."
  default     = "us-central1"
}

variable "name" {
  type        = string
  description = "The name of the bucket."
}

variable "force_destroy" {
  type        = bool
  description = "When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run."
  default     = false
}

