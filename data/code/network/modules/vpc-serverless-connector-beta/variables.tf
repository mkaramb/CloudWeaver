
variable "project_id" {
  type        = string
  description = "Project in which the vpc connector will be deployed."
}

variable "vpc_connectors" {
  type        = list(map(string))
  default     = []
  description = "List of VPC serverless connectors."
}
