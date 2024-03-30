
provider "google" {

  project = var.project_id
  region  = var.region
}

resource "google_compute_address" "ip_address" {
  name = "external-ip-alias-ip-range"
}

module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 11.0"

  project_id      = var.project_id
  subnetwork      = var.subnetwork
  service_account = var.service_account
  name_prefix     = "alias-ip-range"

  alias_ip_range = {
    ip_cidr_range         = "/24"
    subnetwork_range_name = var.subnetwork
  }
}
