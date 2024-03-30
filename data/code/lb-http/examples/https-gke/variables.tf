
variable "name" {
  default = "tf-lb-https-gke"
}

variable "service_port" {
  default = "30000"
}

variable "service_port_name" {
  default = "http"
}

variable "target_tags" {
  default = "tf-lb-https-gke"
}

variable "backend" {
  description = "Map backend indices to list of backend maps."
}

variable "network_name" {
  default = "default"
}

variable "project" {
  type = string
}
