


variable "project_id" {
  description = "The GCP project to use for integration tests"
  type        = string
}

variable "region" {
  description = "The GCP region to create and test resources in"
  type        = string
  default     = "us-central1"
}

variable "subnetwork" {
  description = "The subnetwork to host the compute instances in"
}

variable "service_account" {
  default = null
  type = object({
    email  = string
    scopes = set(string)
  })
  description = "Service account email address and scopes"
}
