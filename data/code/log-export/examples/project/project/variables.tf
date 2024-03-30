
variable "project_id" {
  description = "The ID of the project in which the log export will be created."
  type        = string
}

variable "parent_resource_id" {
  description = "The ID of the project to which logs will be routed."
  type        = string
}

