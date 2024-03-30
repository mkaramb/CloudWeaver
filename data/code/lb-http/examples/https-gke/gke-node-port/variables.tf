
variable "network_name" {
  default = "tf-lb-https-gke"
}

variable "node_tag" {
  default = "tf-lb-https-gke"
}

variable "region" {
  default = "us-central1"
}

variable "location" {
  default = "us-central1-f"
}

variable "node_port" {
  default = "30000"
}

variable "port_name" {
  default = "http"
}

