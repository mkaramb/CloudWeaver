
variable "org_id" {
  description = "GCP Organization ID"
  type        = string
}

variable "folder_id" {
  description = "The ID of a folder to host this project"
  type        = string
  default     = ""
}

variable "project_id" {
  description = "Custom project ID to use for project created."
  default     = ""
  type        = string
}

variable "project_labels" {
  description = "Labels to apply to the project."
  type        = map(string)
  default     = {}
}

variable "storage_bucket_labels" {
  description = "Labels to apply to the storage bucket."
  type        = map(string)
  default     = {}
}

variable "location" {
  description = "Location for build artifacts bucket"
  type        = string
  default     = "us-central1"
}

variable "buckets_force_destroy" {
  description = "When deleting CloudBuild buckets, this boolean option will delete all contained objects. If false, Terraform will fail to delete buckets which contain objects."
  type        = bool
  default     = false
}

variable "billing_account" {
  description = "The ID of the billing account to associate projects with."
  type        = string
}

variable "group_org_admins" {
  description = "Google Group for GCP Organization Administrators"
  type        = string
}

variable "activate_apis" {
  description = "List of APIs to enable in the Cloudbuild project."
  type        = list(string)

  default = [
    "serviceusage.googleapis.com",
    "servicenetworking.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
    "iam.googleapis.com",
    "admin.googleapis.com"
  ]
}

variable "cloud_source_repos" {
  description = "List of Cloud Source Repos to create with CloudBuild triggers."
  type        = list(string)

  default = [
    "gcp-policies",
    "gcp-org",
    "gcp-envs",
    "gcp-networks",
    "gcp-projects",
  ]
}
