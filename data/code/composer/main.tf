
module "composer-environment" {
  source = "./modules/create_environment_v1"

  project_id              = var.project_id
  composer_env_name       = var.composer_env_name
  region                  = var.region
  zone                    = var.zone
  network                 = var.network
  subnetwork              = var.subnetwork
  enable_private_endpoint = var.enable_private_endpoint
}
