
variable "project_destination_logbkt_id" {
  description = "The ID of the project in which log bucket destination will be created."
  type        = string
}

variable "parent_resource_project" {
  description = "The ID of the project in which the log export will be created."
  type        = string
}
