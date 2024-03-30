
provider "google" {

  project = var.project_id
  region  = var.region
}

provider "google-beta" {

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

module "mig" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "~> 11.0"

  project_id          = var.project_id
  region              = var.region
  hostname            = "mig-autoscaler"
  autoscaling_enabled = var.autoscaling_enabled
  min_replicas        = var.min_replicas
  autoscaling_cpu     = var.autoscaling_cpu
  instance_template   = module.instance_template.self_link
}

