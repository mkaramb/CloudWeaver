
variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "location" {
  type        = string
  description = "Location of the resource"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "type" {
  description = "The type of resource to upload. Either dag, plugin or data"
  type        = string
}

variable "source_path" {
  description = "The source on the local file system"
  type        = string
}

variable "destination_path" {
  description = "The optional destination path"
  type        = string
  default     = null
}
