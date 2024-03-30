
variable "project_id" {
  description = "The project ID used for the Datalab instance"
  type        = string
}

variable "network_name" {
  description = "The network the Datalab instance will be in"
  type        = string
}

variable "firewall_description" {
  description = "Description for firewall rule"
  type        = string
  default     = "Allow IAP access"
}

variable "target_tags" {
  description = "A list of instance tags indicating sets of instances located in the network that may make network connections as specified"
  type        = list(any)
}

variable "ports" {
  description = "A list of ports to which this rule applies"
  type        = list(any)
}

variable "create_rule" {
  default     = true
  description = "Flag to create or skip Firewall rule creation"
  type        = bool
}

