
variable "project_id" {
  type        = string
  description = "The project ID to manage the Pub/Sub resources"
}

variable "topic_name" {
  type        = string
  description = "The name for the Pub/Sub topic"
}

variable "topic_labels" {
  type        = map(string)
  description = "A map of labels to assign to the Pub/Sub topic"
  default     = {}
}
