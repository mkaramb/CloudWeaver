
variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "cluster_name_suffix" {
  description = "A suffix to append to the default cluster name"
  type        = string
  default     = ""
}

variable "region" {
  description = "The region to host the cluster in"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "The zone to host the cluster in"
  default     = "us-central1-a"
}

variable "enable_fleet_feature" {
  description = "Whether to enable the ACM feature on the fleet."
  type        = bool
  default     = true
}
