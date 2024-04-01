
variable "project_id" {
  type        = string
  description = "The project id to deploy Github Runner"
}
variable "region" {
  type        = string
  description = "The GCP region to deploy instances into"
  default     = "us-east4"
}

variable "network_name" {
  type        = string
  description = "Name for the VPC network"
  default     = "gh-runner-network"
}

variable "create_network" {
  type        = bool
  description = "When set to true, VPC,router and NAT will be auto created"
  default     = true
}

variable "subnetwork_project" {
  type        = string
  description = "The ID of the project in which the subnetwork belongs. If it is not provided, the project_id is used."
  default     = ""
}

variable "subnet_ip" {
  type        = string
  description = "IP range for the subnet"
  default     = "10.10.10.0/24"
}
variable "subnet_name" {
  type        = string
  description = "Name for the subnet"
  default     = "gh-runner-subnet"
}

variable "restart_policy" {
  type        = string
  description = "The desired Docker restart policy for the runner image"
  default     = "Always"
}

variable "image" {
  type        = string
  description = "The github runner image"
}

variable "repo_url" {
  type        = string
  description = "Repo URL for the Github Action"
}

variable "repo_name" {
  type        = string
  description = "Name of the repo for the Github Action"
}


variable "repo_owner" {
  type        = string
  description = "Owner of the repo for the Github Action"
}

variable "gh_token" {
  type        = string
  description = "Github token that is used for generating Self Hosted Runner Token"
}

variable "instance_name" {
  type        = string
  description = "The gce instance name"
  default     = "gh-runner"
}

variable "target_size" {
  type        = number
  description = "The number of runner instances"
  default     = 2
}

variable "service_account" {
  description = "Service account email address"
  type        = string
  default     = ""
}
variable "additional_metadata" {
  type        = map(any)
  description = "Additional metadata to attach to the instance"
  default     = {}
}

variable "dind" {
  type        = bool
  description = "Flag to determine whether to expose dockersock "
  default     = false
}

variable "cooldown_period" {
  description = "The number of seconds that the autoscaler should wait before it starts collecting information from a new instance."
  type        = number
  default     = 60
}