
variable "org_id" {
  description = "Organization ID. e.g. 1234567898765"
  type        = string
}

variable "billing_account" {
  description = "Billing Account id. e.g. AAAAAA-BBBBBB-CCCCCC"
  type        = string
}

variable "folder_id" {
  description = "Folder ID within the Organization: e.g. 1234567898765"
  type        = string
  default     = ""
}
variable "members" {
  description = "List of members in the standard GCP form: user:{email}, serviceAccount:{email}, group:{email}"
  type        = list(string)
  default     = []
}

variable "terraform_service_account" {
  type        = string
  description = "The Terraform service account email that should still be allowed in the perimeter to create buckets, datasets, etc."
}

variable "region" {
  description = "Region where the bastion host will run"
  type        = string
  default     = "us-west1"
}

variable "zone" {
  description = "Zone where the bastion host will run"
  type        = string
  default     = "us-west1-a"
}

variable "enabled_apis" {
  description = "List of APIs to enable on the created projects"
  type        = list(string)
  default = [
    "iap.googleapis.com",
    "oslogin.googleapis.com",
    "compute.googleapis.com",
    "bigquery.googleapis.com",
    "storage-api.googleapis.com",
  ]
}
