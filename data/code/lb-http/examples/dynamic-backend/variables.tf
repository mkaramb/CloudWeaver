
variable "project" {
  type = string
}

variable "domains" {
  description = "Domain names to use in managed certificate"
  type        = list(string)
  default     = ["example.com"]
}
