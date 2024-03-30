
variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "uptime_check_display_name" {
  description = "The ID of the project in which to provision resources."
  type        = string
  default     = "example-uptime-check-name"
}

variable "hostname" {
  description = "The base hostname for the uptime check."
  type        = string
  default     = "example-hostname.com"
}

variable "email" {
  description = "Email address to alert if uptime check fails."
  type        = string
  default     = "example-email@gmail.com"
}

# Uncomment if you'd like to add an SMS notification channel
# variable "sms" {
#   description = "Phone number (including country code) to alert if uptime check fails."
#   type        = string
#   default     = "example-number"
# }
