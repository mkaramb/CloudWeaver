
variable "project_id" {
  description = "The ID of the project in which the log export will be created."
  type        = string
}

variable "parent_resource_id" {
  description = "The ID of the project in which pubsub topic destination will be created."
  type        = string
}

variable "push_endpoint" {
  description = "The URL locating the endpoint to which messages should be pushed."
  type        = string
}

variable "key_output_path" {
  description = "The path to a directory where the JSON private key of the new Datadog service account will be created."
  type        = string
  default     = "../datadog-sink/datadog-sa-key.json"
}
