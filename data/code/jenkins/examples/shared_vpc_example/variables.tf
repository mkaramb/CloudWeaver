
variable "project_id" {
  description = "The project ID to deploy jenkins to"
}

variable "svpc_host_project_id" {
  description = "The Shared VPC host project ID. In example the project the Jenkins network is hosted in"
}

variable "svpc_network_name" {
  description = "The network in Shared VPC host account to deploy the Jenkins instance to"
}

variable "svpc_subnetwork_name" {
  description = "The subnetwork name to deploy Jenkins to"
}
