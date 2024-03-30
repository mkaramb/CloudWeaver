
variable "project_id" {
  description = "Project id of the project that holds the network."
  type        = string
}

variable "network_name" {
  description = "Name of the network this set of firewall rules applies to."
  type        = string
}

variable "rules" {
  description = "This is DEPRICATED and available for backward compatiblity. Use ingress_rules and egress_rules variables. List of custom rule definitions"
  default     = []
  type = list(object({
    name                    = string
    description             = optional(string, null)
    direction               = optional(string, "INGRESS")
    disabled                = optional(bool, null)
    priority                = optional(number, null)
    ranges                  = optional(list(string), [])
    source_tags             = optional(list(string))
    source_service_accounts = optional(list(string))
    target_tags             = optional(list(string))
    target_service_accounts = optional(list(string))

    allow = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])
    deny = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])
    log_config = optional(object({
      metadata = string
    }))
  }))
}

variable "ingress_rules" {
  description = "List of ingress rules. This will be ignored if variable 'rules' is non-empty"
  default     = []
  type = list(object({
    name                    = string
    description             = optional(string, null)
    disabled                = optional(bool, null)
    priority                = optional(number, null)
    destination_ranges      = optional(list(string), [])
    source_ranges           = optional(list(string), [])
    source_tags             = optional(list(string))
    source_service_accounts = optional(list(string))
    target_tags             = optional(list(string))
    target_service_accounts = optional(list(string))

    allow = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])
    deny = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])
    log_config = optional(object({
      metadata = string
    }))
  }))
}

variable "egress_rules" {
  description = "List of egress rules. This will be ignored if variable 'rules' is non-empty"
  default     = []
  type = list(object({
    name                    = string
    description             = optional(string, null)
    disabled                = optional(bool, null)
    priority                = optional(number, null)
    destination_ranges      = optional(list(string), [])
    source_ranges           = optional(list(string), [])
    source_tags             = optional(list(string))
    source_service_accounts = optional(list(string))
    target_tags             = optional(list(string))
    target_service_accounts = optional(list(string))

    allow = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])
    deny = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])
    log_config = optional(object({
      metadata = string
    }))
  }))
}
