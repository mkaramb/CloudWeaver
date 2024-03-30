
variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "location" {
  description = "Location for the keyring."
  type        = string
  default     = "global"
}

variable "keyring" {
  description = "Keyring name."
  type        = string
}

variable "keys" {
  description = "Key names."
  type        = list(string)
  default     = []
}
