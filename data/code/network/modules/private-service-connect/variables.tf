
variable "project_id" {
  description = "Project ID for Private Service Connect."
  type        = string
}

variable "network_self_link" {
  description = "Network self link for Private Service Connect."
  type        = string
}

variable "dns_code" {
  description = "Code to identify DNS resources in the form of `{dns_code}-{dns_type}`"
  type        = string
  default     = "dz"
}

variable "private_service_connect_name" {
  description = "Private Service Connect endpoint name. Defaults to `global-psconnect-ip`"
  type        = string
  default     = "global-psconnect-ip"
}

variable "private_service_connect_ip" {
  description = "The internal IP to be used for the private service connect."
  type        = string
}

variable "forwarding_rule_name" {
  description = "Forwarding rule resource name. The forwarding rule name for PSC Google APIs must be an 1-20 characters string with lowercase letters and numbers and must start with a letter. Defaults to `globalrule`"
  type        = string
  default     = "globalrule"
}

variable "forwarding_rule_target" {
  description = "Target resource to receive the matched traffic. Only `all-apis` and `vpc-sc` are valid."
  type        = string

  validation {
    condition     = var.forwarding_rule_target == "all-apis" || var.forwarding_rule_target == "vpc-sc"
    error_message = "For forwarding_rule_target only `all-apis` and `vpc-sc` are valid."
  }
}

variable "service_directory_namespace" {
  description = "Service Directory namespace to register the forwarding rule under."
  type        = string
  default     = null
}

variable "service_directory_region" {
  description = "Service Directory region to register this global forwarding rule under. Defaults to `us-central1` if not defined."
  type        = string
  default     = null
}
