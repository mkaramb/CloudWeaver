
variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "description" {
  description = "The description of the policy."
  type        = string
  default     = null
}

variable "agent_rules" {
  description = "A list of agent rules to be enforced by the policy."
  type        = list(any)
}

variable "group_labels" {
  description = "A list of label maps to filter instances to apply policies on."
  type        = list(map(string))
  default     = null
}

variable "os_types" {
  description = "A list of label maps to filter instances to apply policies on."
  type        = list(any)
}

variable "zones" {
  description = "A list of zones to filter instances to apply the policy."
  type        = list(string)
  default     = null
}

variable "instances" {
  description = "A list of zones to filter instances to apply the policy."
  type        = list(string)
  default     = null
}
