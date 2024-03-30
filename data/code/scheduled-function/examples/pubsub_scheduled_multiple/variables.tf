
variable "project_id" {
  type        = string
  description = "The project ID to host the network in"
  default     = "flask-app-254610"
}

variable "region" {
  type        = string
  description = "The region the project is in (App Engine specific)"
  default     = "us-central1"
}
