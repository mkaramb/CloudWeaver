
variable "project_id" {
  type        = string
  description = "The ID of the project to which resources will be applied."
}

variable "folder_id" {
  type        = string
  description = "The ID of the folder to look for changes."
}

variable "region" {
  type        = string
  description = "The region in which resources will be applied."
}
