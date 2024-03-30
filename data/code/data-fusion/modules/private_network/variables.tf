
variable "project_id" {
  description = "GCP Project ID to house resources for private Data Fusion setup"
  type        = string
}


variable "network_name" {
  description = "VPC network to be created or configured with firewall rules and peering for private Data Fusion instance"
  type        = string
}

variable "instance" {
  description = "Private Data Fusion instance ID"
  type        = string
}

variable "tenant_project" {
  description = "Private Data Fusion instance ID"
  type        = string
}

variable "data_fusion_service_account" {
  description = "The Google managed Data Fusion Service account"
  type        = string
}

variable "region" {
  description = "GCP region to create subnetwork for peering with private Data Fusion instance"
  type        = string
  default     = "us-central1"
}

variable "dataproc_subnet" {
  description = "Name of the subnetwork for Dataproc clusters controlled by private Data Fusion instance"
  type        = string
  default     = "dataproc-subnet"
}

variable "dataproc_cidr" {
  description = "CIDR range for the subnetwork for Dataproc clusters controlled by private Data Fusion instance"
  type        = string
  default     = "10.2.0.0/16"
}

