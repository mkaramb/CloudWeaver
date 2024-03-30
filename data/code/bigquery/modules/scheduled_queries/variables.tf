
variable "project_id" {
  description = "The project where scheduled queries are created"
  type        = string
}

variable "queries" {
  description = "Data transfer configuration for creating scheduled queries"
  type        = list(any)
}
