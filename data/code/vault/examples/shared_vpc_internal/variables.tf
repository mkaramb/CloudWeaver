
variable "host_project_id" {}

variable "service_project_id" {}

variable "kms_keyring" {
  default = "vault-keyring"
}

variable "subnet_name" {
  default = "vault"
}

variable "service_account_name" {
  default = "vault-svpc-admin"
}
variable "region" {
  default = "us-west1"
}
