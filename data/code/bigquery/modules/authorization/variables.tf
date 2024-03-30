
variable "dataset_id" {
  description = "Unique ID for the dataset being provisioned."
  type        = string
}

variable "project_id" {
  description = "Project where the dataset and table are created"
  type        = string
}

# Format: list(objects)
# domain: A domain to grant access to.
# group_by_email: An email address of a Google Group to grant access to.
# user_by_email:  An email address of a user to grant access to.
# group_by_email: An email address of a Google Group to grant access to.
# special_group: A special group to grant access to.
variable "roles" {
  description = "An array of objects that define dataset access for one or more entities."
  type        = any
  default     = []
}

variable "authorized_views" {
  description = "An array of views to give authorize for the dataset"
  type = list(object({
    dataset_id = string,
    project_id = string,
    table_id   = string # this is the view id, but we keep table_id to stay consistent as the resource
  }))
  default = []
}

variable "authorized_datasets" {
  description = "An array of datasets to be authorized on the dataset"
  type = list(object({
    dataset_id = string,
    project_id = string,
  }))
  default = []
}

variable "authorized_routines" {
  description = "An array of authorized routine to be authorized on the dataset"
  type = list(object({
    project_id = string,
    dataset_id = string,
    routine_id = string
  }))
  default = []
}
