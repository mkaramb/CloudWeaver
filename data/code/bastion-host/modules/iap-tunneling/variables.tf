
variable "host_project" {
  description = "The network host project ID."
  type        = string
  default     = ""
}

variable "project" {
  description = "The project ID to deploy to."
  type        = string
}

variable "fw_name_allow_ssh_from_iap" {
  description = "Firewall rule name for allowing SSH from IAP."
  type        = string
  default     = "allow-ssh-from-iap-to-tunnel"
}

variable "network" {
  description = "Self link of the network to attach the firewall to."
  type        = string
}

variable "service_accounts" {
  description = "Service account emails associated with the instances to allow SSH from IAP. Exactly one of service_accounts or network_tags should be specified."
  type        = list(string)
  default     = []
}

variable "network_tags" {
  description = "Network tags associated with the instances to allow SSH from IAP. Exactly one of service_accounts or network_tags should be specified."
  type        = list(string)
  default     = []
}

variable "instances" {
  type = list(object({
    name = string
    zone = string
  }))
  description = "Names and zones of the instances to allow SSH from IAP."
}

variable "members" {
  description = "List of IAM resources to allow using the IAP tunnel."
  type        = list(string)
}

variable "additional_ports" {
  description = "A list of additional ports/ranges to open access to on the instances from IAP."
  type        = list(string)
  default     = []
}

variable "create_firewall_rule" {
  type        = bool
  description = "If we need to create the firewall rule or not."
  default     = true
}
