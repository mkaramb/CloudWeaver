
variable "org_id" {
  description = "The organization ID for the associated services"
  type        = string
}

variable "function_region" {
  description = "Region for the Cloud function resources. See https://cloud.google.com/functions/docs/locations for valid values."
  type        = string
}

variable "bigquery_location" {
  description = "Location for BigQuery resources. See https://cloud.google.com/bigquery/docs/locations for valid values."
  type        = string
  default     = "US"
}

variable "source_name" {
  description = "The Security Command Center Source name for the \"BQ Log Alerts\" Source if the source had been created before. The format is `organizations/<ORG_ID>/sources/<SOURCE_ID>`"
  type        = string
  default     = ""
}

variable "logging_project" {
  description = "The project to deploy the submodule"
  type        = string
}
