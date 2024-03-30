
variable "project_id" {
  description = "The ID of the GCP project that is going to be created"
}

variable "organization_id" {
  description = "Organization ID, which can be found at `gcloud organizations list`"
}

variable "billing_account_id" {
  description = "Billing account ID to which the new project should be associated"
}

variable "region" {
  description = "GCP Region (like us-west1, us-central1, etc)"
  default     = "us-west1"
}

variable "ip_addr_cloud_vpn_router" {
  description = "IP address that is reserved for the VPC SC project's VPN router"
}

variable "vpn_shared_secret" {
  description = "Shared secret string for VPN connection"
}
