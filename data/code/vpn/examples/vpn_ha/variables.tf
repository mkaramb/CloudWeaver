
variable "prod_project_id" {
  description = "Production Project ID."
  type        = string
}

variable "prod_network_self_link" {
  description = "Production Network Self Link."
  type        = string
}

variable "mgt_project_id" {
  description = "Management Project ID."
  type        = string
}

variable "mgt_network_self_link" {
  description = "Management Network Self Link."
  type        = string
}

variable "region" {
  description = "Region."
  type        = string
  default     = "europe-west4"
}
