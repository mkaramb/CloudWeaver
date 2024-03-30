
variable "cluster_name" {
  description = "The GKE cluster name"
  type        = string
}

variable "project_id" {
  description = "The project in which the GKE cluster belongs."
  type        = string
}

variable "hub_project_id" {
  description = "The project in which the GKE Hub belongs. Defaults to GKE cluster project_id."
  type        = string
  default     = ""
}

variable "location" {
  description = "The location (zone or region) this cluster has been created in."
  type        = string
}

variable "enable_fleet_registration" {
  description = "Enables GKE Hub Registration when set to true"
  type        = bool
  default     = true
}

variable "membership_name" {
  description = "Membership name that uniquely represents the cluster being registered. Defaults to `$project_id-$location-$cluster_name`."
  type        = string
  default     = ""
}

// Defaults to global for backward compatibility.
variable "membership_location" {
  description = "Membership location for the cluster. Defaults to global."
  type        = string
  default     = "global"
}
