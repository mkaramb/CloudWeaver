
variable "service_project_id" {
  description = "Project ID where Cloud Composer Environment is created."
  type        = string
}


variable "region" {
  description = "Region where the Cloud Composer Environment is created."
  type        = string
  default     = "us-central1"
}


variable "network" {
  type        = string
  description = "The VPC network to host the composer cluster."
}

variable "network_project_id" {
  type        = string
  description = "The project ID of the shared VPC's host (for shared vpc support)"
}

variable "subnetwork" {
  type        = string
  description = "The subnetwork to host the composer cluster."
}

variable "master_ipv4_cidr" {
  description = "The CIDR block from which IP range in tenant project will be reserved for the master."
  type        = string
  default     = null
}


variable "cloud_composer_network_ipv4_cidr_block" {
  description = "The CIDR block from which IP range in tenant project will be reserved."
  type        = string
  default     = null
}


variable "gke_subnet_ip_range" {
  type        = list(string)
  description = "The GKE subnet IP range"
}

variable "gke_pods_services_ip_ranges" {
  type        = list(string)
  description = "The secondary IP ranges for the GKE Pods and Services IP ranges"
}


variable "composer_env_name" {
  description = "Name of Cloud Composer Environment"
  type        = string
}
