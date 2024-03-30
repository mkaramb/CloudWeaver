
variable "organization_id" {
  description = "The organization id for putting the policy"
  type        = string
}

variable "excluded_folder_id" {
  description = "ID of a folder to exclude from the policy"
  type        = string
}
