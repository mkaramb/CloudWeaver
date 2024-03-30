
variable "parent_id" {
  description = "The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent."
  type        = string
}

variable "policy_name" {
  description = "The policy's name."
  type        = string
}

variable "protected_project_ids" {
  description = "Project id and number of the project INSIDE the regular service perimeter. This map variable expects an \"id\" for the project id and \"number\" key for the project number."
  type        = object({ id = string, number = number })
}

variable "public_project_ids" {
  description = "Project id and number of the project OUTSIDE of the regular service perimeter. This variable is only necessary for running integration tests. This map variable expects an \"id\" for the project id and \"number\" key for the project number."
  type        = object({ id = string, number = number })
}
