
variable "project" {
  type        = string
  description = "The project id"
}

variable "location_id" {
  type        = string
  description = "App Engine Location"
  default     = "us-east1"
}

variable "indexes_file_path" {
  type        = string
  description = "Path to the file with indexes. Default is yaml/index.yaml"
  default     = "yaml/index.yaml"
}

