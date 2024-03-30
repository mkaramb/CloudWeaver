
variable "project_id" {
  type        = string
  description = "The project ID to deploy to"
}

variable "dns_domain" {
  type        = string
  description = "The name of the domain to be registered with Cloud DNS"
}

variable "region" {
  type        = string
  description = "The region to deploy to"
}

variable "subnetwork" {
  type        = string
  description = "The subnet containing the address.  For EXTERNAL addresses use the empty string, \"\".  (e.g. \"projects/<project-name>/regions/<region-name>/subnetworks/<subnetwork-name>\")"
}

variable "names" {
  description = "A list of IP address resource names to create.  This is the GCP resource name and not the associated hostname of the IP address.  Existing resource names may be found with `gcloud compute addresses list` (e.g. [\"gusw1-dev-fooapp-fe-0001-a-001-ip\"])"
  type        = list(string)
}

variable "dns_short_names" {
  description = "A list of DNS short names to register within Cloud DNS.  Names corresponding to addresses must align by their list index position in the two input variables, `names` and `dns_short_names`.  If an empty list, no domain names are registered.  Multiple names may be registered to the same address by passing a single element list to names and multiple elements to dns_short_names.  (e.g. [\"gusw1-dev-fooapp-fe-0001-a-001\"])"
  type        = list(string)
}

variable "dns_managed_zone" {
  type        = string
  description = "The name of the managed zone to create records within.  This managed zone must exist in the host project."
}

variable "dns_project" {
  type        = string
  description = "The project where DNS A records will be configured."
}

