
variable "parent_id" {
  type        = string
  description = "Id of the resource under which the folder will be placed."
}

variable "parent_type" {
  type        = string
  description = "Type of the parent resource. One of `organizations` or `folders`."
  default     = "folders"
}

variable "all_folder_admins" {
  type        = list(string)
  description = "List of IAM-style members that will get the extended permissions across all the folders."
  default     = []
}

