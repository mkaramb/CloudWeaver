
variable "name" {
  description = "Name of the instance."
  type        = string
}

variable "project" {
  description = "The project ID to deploy to."
  type        = string
}

variable "datafusion_version" {
  description = "Data Fusion Version to deploy."
  type        = string
  default     = null
}

variable "network" {
  description = "Name for VPC to create or reuse to be configured for use with private Data Fusion instance."
  type        = string
}

variable "dataproc_subnet" {
  description = "Name for subnet to create and configure for Dataproc clusters controlled by private Data Fusion instance."
  type        = string
  default     = "dataproc-subnet"
}

variable "description" {
  description = "An optional description of the instance."
  type        = string
  default     = null
}

variable "region" {
  description = "The region of the instance."
  type        = string
}

variable "type" {
  description = "Represents the type of the instance (BASIC or ENTERPRISE)"
  type        = string
  default     = "ENTERPRISE"
}

variable "labels" {
  description = "The resource labels for instance to use to annotate any related underlying resources, such as Compute Engine VMs."
  type        = map(string)
  default     = {}
}

variable "options" {
  description = "Map of additional options used to configure the behavior of Data Fusion instance."
  type        = map(string)
  default     = {}
}
