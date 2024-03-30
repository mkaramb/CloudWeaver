
variable "function_timeout_s" {
  type        = number
  default     = 500
  description = "The amount of time in seconds allotted for the execution of the function."
}

variable "organization_id" {
  type        = string
  description = "The organization ID whose projects to clean up"
}

variable "project_id" {
  type        = string
  description = "The project ID to host the scheduled function in"
}

variable "region" {
  type        = string
  description = "The region the project is in (App Engine specific)"
}

variable "job_schedule" {
  type        = string
  description = "Cleaner function run frequency, in cron syntax"
  default     = "*/5 * * * *"
}

variable "topic_name" {
  type        = string
  description = "Name of pubsub topic connecting the scheduled projects cleanup function"
  default     = "pubsub_scheduled_project_cleaner"
}

variable "target_tag_name" {
  type        = string
  description = "The name of a tag to filter GCP projects on for consideration by the cleanup utility (legacy, use `target_included_labels` map instead)."
  default     = ""
}

variable "target_tag_value" {
  type        = string
  description = "The value of a tag to filter GCP projects on for consideration by the cleanup utility (legacy, use `target_included_labels` map instead)."
  default     = ""
}

variable "max_project_age_in_hours" {
  type        = number
  description = "The maximum number of hours that a GCP project, selected by `target_tag_name` and `target_tag_value`, can exist"
  default     = 6
}

variable "target_excluded_labels" {
  type        = map(string)
  description = "Map of project lablels that won't be deleted."
  default     = {}
}

variable "target_included_labels" {
  type        = map(string)
  description = "Map of project lablels that will be deleted."
  default     = {}
}

variable "clean_up_org_level_tag_keys" {
  type        = bool
  description = "Clean up organization level Tag Keys."
  default     = false
}

variable "target_excluded_tagkeys" {
  type        = list(string)
  description = "List of organization Tag Key short names that won't be deleted."
  default     = []
}

variable "target_folder_id" {
  type        = string
  description = "Folder ID to delete all projects under."
  default     = ""
}
