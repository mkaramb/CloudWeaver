
provider "google" {

  project = var.project_id
  region  = var.region
}

module "preemptible_and_regular_instance_templates" {
  source  = "terraform-google-modules/vm/google//modules/preemptible_and_regular_instance_templates"
  version = "~> 11.0"

  subnetwork      = var.subnetwork
  project_id      = var.project_id
  service_account = var.service_account
  name_prefix     = "pvm-and-regular-simple"
  tags            = var.tags
  labels          = var.labels
}
