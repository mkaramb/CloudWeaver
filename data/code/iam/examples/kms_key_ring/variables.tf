
variable "group_email" {
  type        = string
  description = "Email for group to receive roles (ex. group@example.com)"
}

variable "user_email" {
  type        = string
  description = "Email for group to receive roles (Ex. user@example.com)"
}

/******************************************
  kms_key_ring_iam_binding variables
 *****************************************/
variable "kms_key_ring_one" {
  type        = string
  description = "First kms_ring to add the IAM policies/bindings"
}

variable "kms_key_ring_two" {
  type        = string
  description = "First kms_ring to add the IAM policies/bindings"
}

