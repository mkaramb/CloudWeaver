
provider "google" {

  project = var.project_id
  region  = var.region
}

provider "google-beta" {

  project = var.project_id
  region  = var.region
}

module "preemptible_and_regular_instance_templates" {
  source  = "terraform-google-modules/vm/google//modules/preemptible_and_regular_instance_templates"
  version = "~> 11.0"

  subnetwork      = var.subnetwork
  service_account = var.service_account
}

module "mig_with_percent" {
  source  = "terraform-google-modules/vm/google//modules/mig_with_percent"
  version = "~> 11.0"

  region                            = var.region
  target_size                       = 4
  hostname                          = "mig-with-percent-simple"
  instance_template_initial_version = module.preemptible_and_regular_instance_templates.regular_self_link
  instance_template_next_version    = module.preemptible_and_regular_instance_templates.preemptible_self_link
  next_version_percent              = 50
}
