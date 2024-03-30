
variable "additional_regions" {
  description = "A user-supplied list of regions to extend the lookup map."
  type        = list(string)
  default     = []
}

variable "region" {
  description = "The GCP region to retrieve a short name for (ex. `us-central1)."
  type        = string
  default     = null
}
