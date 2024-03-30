
variable "project_id" {
  description = "Project id"
}

variable "schedule" {
  description = "Cron-like Cloud Scheduler schedule"
  default     = "* * * * */1"
}

variable "region" {
  description = "Region"
  default     = "us-east1"
}

variable "gcr_project_id" {
  description = "Google Container registry project where image is hosted"
  default     = "slo-generator-ci-a2b4"
}

variable "slo_generator_version" {
  description = "SLO generator version"
  default     = "latest"
}

variable "labels" {
  description = "Project labels"
  default     = {}
}
