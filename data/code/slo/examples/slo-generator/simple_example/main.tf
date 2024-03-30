
locals {
  config = yamldecode(file("${path.module}/configs/config.yaml"))
  slo_configs = [
    for cfg_path in fileset(path.module, "/configs/slo_*.yaml") :
    yamldecode(file("${path.module}/${cfg_path}"))
  ]
}

module "slo-generator" {
  source  = "terraform-google-modules/slo/google//modules/slo-generator"
  version = "~> 3.0"

  project_id            = var.project_id
  region                = var.region
  config                = local.config
  slo_configs           = local.slo_configs
  slo_generator_version = var.slo_generator_version
  gcr_project_id        = var.gcr_project_id
  secrets = {
    PROJECT_ID = var.project_id
  }
}
