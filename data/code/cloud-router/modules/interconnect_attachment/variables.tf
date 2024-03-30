
variable "name" {
  type        = string
  description = "The name of the interconnect attachment"
}

variable "project" {
  type        = string
  description = "The project ID to deploy to"
}

variable "router" {
  type        = string
  description = "Name of the router the attachment resides"
}

variable "region" {
  type        = string
  description = "Region where the attachment resides"
}

variable "interconnect" {
  type        = string
  description = "URL of the underlying Interconnect object that this attachment's traffic will traverse through."
}

variable "admin_enabled" {
  type        = bool
  description = "Whether the VLAN attachment is enabled or disabled"
  default     = true
}

variable "type" {
  type        = string
  description = "The type of InterconnectAttachment you wish to create"
  default     = "DEDICATED"
}

variable "bandwidth" {
  type        = string
  description = "Provisioned bandwidth capacity for the interconnect attachment"
  default     = "BPS_10G"
}

variable "mtu" {
  type        = string
  description = "Maximum Transmission Unit (MTU), in bytes, of packets passing through this interconnect attachment. Currently, only 1440 and 1500 are allowed. If not specified, the value will default to 1440."
  default     = null
}

variable "description" {
  type        = string
  description = "An optional description of this resource"
  default     = null
}

variable "candidate_subnets" {
  type        = list(string)
  description = "Up to 16 candidate prefixes that can be used to restrict the allocation of cloudRouterIpAddress and customerRouterIpAddress for this attachment. All prefixes must be within link-local address space (169.254.0.0/16) and must be /29 or shorter (/28, /27, etc)."
  default     = null
}

variable "vlan_tag8021q" {
  type        = string
  description = "The IEEE 802.1Q VLAN tag for this attachment, in the range 2-4094."
  default     = null
}

variable "interface" {
  description = "Interface to deploy for this attachment."
  type = object({
    name = string
  })
}

variable "peer" {
  description = "BGP Peer for this attachment."
  type = object({
    name                      = string
    peer_asn                  = string
    advertised_route_priority = optional(number)
    bfd = optional(object({
      session_initialization_mode = string
      min_transmit_interval       = optional(number)
      min_receive_interval        = optional(number)
      multiplier                  = optional(number)
    }))
  })
}
