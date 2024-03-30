
variable "parent_id" {
  description = "The parent of this AccessPolicy in the Cloud Resource Hierarchy. As of now, only organization are accepted as parent."
  type        = string
}

variable "policy_name" {
  description = "The policy's name."
  type        = string
  default     = "vpc-sc"
}

variable "billing_account" {
  description = "The billing account to use for creating projects"
  type        = string
}
