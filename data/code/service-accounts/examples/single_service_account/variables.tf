
variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "prefix" {
  type        = string
  description = "Prefix applied to service account names."
  default     = ""
}

