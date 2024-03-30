
variable "group_email" {
  type        = string
  description = "Email for group to receive roles (ex. group@example.com)"
}

variable "user_email" {
  type        = string
  description = "Email for group to receive roles (Ex. user@example.com)"
}

/******************************************
  kms_crypto_key_iam_binding variables
 *****************************************/
variable "kms_crypto_key_one" {
  type        = string
  description = "First kms_cripto_key to add the IAM policies/bindings"
}

variable "kms_crypto_key_two" {
  type        = string
  description = "Second kms_cripto_key to add the IAM policies/bindings"
}

