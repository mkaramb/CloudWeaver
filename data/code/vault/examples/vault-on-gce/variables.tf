

variable "project_id" {
  type        = string
  description = "Project ID in which to deploy"
}

variable "region" {
  type        = string
  default     = "us-east4"
  description = "Region in which to deploy"
}

variable "kms_keyring" {
  type        = string
  default     = "vault"
  description = "Name of the GCP KMS keyring"
}

variable "kms_crypto_key" {
  type        = string
  default     = "vault-init"
  description = "Name of the GCP KMS crypto key"
}

variable "load_balancing_scheme" {
  type        = string
  default     = "EXTERNAL"
  description = "e.g. [INTERNAL|EXTERNAL]. Scheme of the load balancer"
}

variable "allow_public_egress" {
  type        = bool
  default     = true
  description = "Whether to create a NAT for external egress. If false, you must also specify an http_proxy to download required executables including Vault, Fluentd and Stackdriver"
}


