
variable "organization_id" {
  description = "The organization id for putting the policy"
  type        = string
}

variable "domains_to_allow" {
  description = "The list of domains to allow users from"
  type        = list(string)
}

variable "vms_to_allow" {
  description = "The list of VMs are allowed to use external IP, every element of the list must be identified by the VM instance name, in the form: projects/PROJECT_ID/zones/ZONE/instances/INSTANCE"
  type        = list(string)
  default     = []
}
