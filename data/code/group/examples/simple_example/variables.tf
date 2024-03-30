
variable "project_id" {
  description = "The ID of the project in which to provision resources and used for billing"
  type        = string
}

variable "domain" {
  description = "Domain of the organization to create the group in"
  type        = string
}

variable "suffix" {
  description = "Suffix of the groups to create"
  type        = string
}
