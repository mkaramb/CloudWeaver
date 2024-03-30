
variable "filter" {
  type        = string
  description = "The filter to apply when exporting logs."
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "A set of key/value label pairs to assign to any labelable resources."
}

variable "name" {
  type        = string
  description = "The name to apply to any nameable resources."
}

variable "project_id" {
  type        = string
  description = "The ID of the project to which resources will be applied."
}

variable "folder_id" {
  type        = string
  description = "The ID of the folder to look for changes."
}

variable "include_children" {
  description = "Determines whether or not to include folder's children in the sink export. If true, logs associated with child projects are also exported; otherwise only logs relating to the provided folder are included."
  type        = bool
  default     = false
}
