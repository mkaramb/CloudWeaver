
variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
}

variable "jobs" {
  description = "A list of Jenkins jobs to populate"
  default     = []

  type = list(object({
    name     = string
    builders = list(string)
  }))
}

variable "jobs_count" {
  description = "Amount of jobs to populate"
  type        = number
  default     = 0
}

variable "bucket_name" {
  description = "The bucket name"
  type        = string
}

