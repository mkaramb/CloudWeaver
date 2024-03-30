
variable "project_id" {
  description = "The ID of the project in which storage bucket destination will be created."
  type        = string
}

variable "parent_resource_organization" {
  description = "The ID of the organization in which the log export will be created."
  type        = string
}
