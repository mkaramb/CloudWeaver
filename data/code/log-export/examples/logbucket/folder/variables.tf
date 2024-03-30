
variable "project_id" {
  description = "The ID of the project in which log bucket destination will be created."
  type        = string
}

variable "parent_resource_folder" {
  description = "The ID of the folder in which the log export will be created."
  type        = string
}
