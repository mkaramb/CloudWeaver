
variable "project_id" {
  description = "Project id where the zone will be created."
  default     = ""
}

variable "network_self_link" {
  description = "Self link of the network that will be allowed to query the zone."
  default     = ""
}

variable "target_network_self_link" {
  description = "Self link of the network that the zone will peer to."
  default     = ""
}

variable "name" {
  description = "DNS zone name."
  default     = "foo-local"
}

variable "domain" {
  description = "Zone domain."
  default     = "foo.local."
}

variable "labels" {
  type        = map(any)
  description = "A set of key/value label pairs to assign to this ManagedZone"
  default = {
    owner   = "foo"
    version = "bar"
  }
}
