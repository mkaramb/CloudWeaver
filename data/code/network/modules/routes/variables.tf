
variable "project_id" {
  description = "The ID of the project where the routes will be created"
  type        = string
}

variable "network_name" {
  description = "The name of the network where routes will be created"
  type        = string
}

variable "routes" {
  type        = list(map(string))
  description = "List of routes being created in this VPC"
  default     = []
}

variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list(any)
  default     = []
}
