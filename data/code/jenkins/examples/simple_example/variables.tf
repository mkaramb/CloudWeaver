
variable "project_id" {
  description = "The project ID to deploy to"
}

variable "region" {
  description = "The region to deploy to"
  default     = "us-east4"
}

variable "network" {
  description = "The GCP network to launch the instance in"
  default     = "default"
}

variable "jenkins_instance_metadata" {
  description = "Additional metadata to pass to the Jenkins master instance"
  type        = map(string)
  default     = {}
}

variable "subnetwork" {
  description = "The GCP subnetwork to launch the instance in"
  default     = "default"
}

variable "jenkins_instance_zone" {
  description = "The zone to deploy the Jenkins VM in"
  default     = "us-east4-b"
}

variable "jenkins_workers_zone" {
  description = "The name of the zone into which to deploy Jenkins workers"
  default     = "us-east4-c"
}

variable "jenkins_network_project_id" {
  description = "The project ID of the Jenkins network"
  default     = ""
}
