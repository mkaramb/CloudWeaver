
variable "project_id" {
  type        = string
  description = "The project ID to deploy to"
}

variable "region" {
  type        = string
  description = "The region to deploy to"
}

variable "subnetwork" {
  type        = string
  description = "The subnetwork on which the IP address will be reserved"
}

variable "names" {
  description = "A list of IP address resource names to create.  This is the GCP resource name and not the associated hostname of the IP address.  Existing resource names may be found with `gcloud compute addresses list` (e.g. [\"gusw1-dev-fooapp-fe-0001-a-001-ip\"])"
  type        = list(string)
}

