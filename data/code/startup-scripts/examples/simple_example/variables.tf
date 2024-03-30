
variable "project_id" {
  description = "The project_id to deploy the example instance into.  (e.g. \"simple-sample-project-1234\")"
}

variable "region" {
  description = "The region to deploy to"
}

variable "network" {
  description = "The network name to deploy to"
  default     = "default"
}
