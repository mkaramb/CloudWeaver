
variable "region" {
  description = "Region"
  default     = "us-east1"
}

variable "project_id" {
  description = "SRE Project id"
}

variable "team1_project_id" {
  description = "Team 1 project id"
}

variable "gcr_project_id" {
  description = "Google Container Registry project to fetch slo-generator image from"
  default     = "slo-generator-ci-a2b4"
}

variable "slo_generator_version" {
  description = "Version of slo-generator image"
  default     = "latest"
}
