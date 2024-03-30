
variable "project_id" {
  type        = string
  description = "Project ID where Cloud Composer Environment is created."
}

variable "zone" {
  type        = string
  description = "Zone where the Cloud Composer Kubernetes Master lives."
}

variable "gke_cluster" {
  type        = string
  description = "Name of the Cloud Composer Kubernetes cluster."
}

variable "master_authorized_networks" {
  type        = list(object({ cidr_block = string, display_name = string }))
  description = "List of master authorized networks. If null is provided this module will do nothing. If empty string then all public traffic will be denied"
  default     = null
}



