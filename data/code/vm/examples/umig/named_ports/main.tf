
provider "google" {

  project = var.project_id
  region  = var.region
}

module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 11.0"

  project_id      = var.project_id
  subnetwork      = var.subnetwork
  service_account = var.service_account
}

module "umig" {
  source  = "terraform-google-modules/vm/google//modules/umig"
  version = "~> 11.0"

  project_id        = var.project_id
  subnetwork        = var.subnetwork
  num_instances     = var.num_instances
  hostname          = "umig-named-ports"
  instance_template = module.instance_template.self_link
  named_ports       = var.named_ports
  region            = var.region
}
