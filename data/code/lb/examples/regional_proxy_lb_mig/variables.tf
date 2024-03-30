

variable "project_id" {
  type        = string
  description = "The project to deploy to, if not set the default provider project is used."
  default     = null
}

variable "region" {
  description = "The region of the load balancer."
  default     = "us-east4"
}

variable "sa_email" {
  type        = string
  description = "Service account to attach to the VM instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template#service_account."
}

