
variable "project_id" {
  type        = string
  description = "The ID of the project to host the watcher function."
}

variable "org_id" {
  description = "The parent organization ID of this AccessPolicy in the Cloud Resource Hierarchy."
  type        = string
}

variable "policy_name" {
  description = "The policy's name."
  type        = string
}

variable "members" {
  description = "An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}"
  type        = list(string)
}

variable "folder_id" {
  description = "Folder ID to watch for projects."
  type        = string
}

variable "perimeter_name" {
  description = "Name of perimeter."
  type        = string
  default     = "regular_perimeter"
}

variable "restricted_services" {
  description = "List of services to restrict."
  type        = list(string)
}

variable "region" {
  type        = string
  description = "The region in which resources will be applied."
}
