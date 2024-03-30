
variable "policy" {
  description = "Name of the parent policy"
  type        = string
}

variable "description" {
  description = "Description of the bridge perimeter"
  type        = string
  default     = ""
}

variable "perimeter_name" {
  description = "Name of the perimeter. Should be one unified string. Must only be letters, numbers and underscores"
  type        = string
}

variable "resources" {
  description = "A list of GCP resources that are inside of the service perimeter. Currently only projects are allowed."
  type        = list(string)
}

variable "resource_keys" {
  description = "A list of keys to use for the Terraform state. The order should correspond to var.resources and the keys must not be dynamically computed. If `null`, var.resources will be used as keys."
  type        = list(string)
  default     = null
}
