
variable "project_id" {
  description = "The project ID to host the network in"
  type        = string
}

variable "slack_webhook" {
  description = "Slack webhook to send alerts"
  type        = string
}

variable "dataset_name" {
  description = "BigQuery Dataset where logs are sent"
  type        = string
}

variable "audit_log_table" {
  description = "BigQuery Table where logs are sent"
  type        = string
}

variable "time_column" {
  description = "BigQuery Column in audit log table representing logging time"
  type        = string
}

variable "error_message_column" {
  description = "BigQuery Column in audit log table representing logging error"
  type        = string
}

variable "region" {
  description = "The region the project is in (App Engine specific)"
  type        = string
  default     = "us-central1"
}

