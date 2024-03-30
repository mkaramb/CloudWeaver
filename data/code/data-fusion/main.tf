

module "data_fusion_network" {
  source                      = "./modules/private_network"
  project_id                  = var.project
  tenant_project              = module.instance.tenant_project
  data_fusion_service_account = module.instance.service_account
  instance                    = module.instance.instance.name
  network_name                = var.network
  dataproc_subnet             = var.dataproc_subnet
  region                      = var.region
}

module "instance" {
  source = "./modules/instance"

  name               = var.name
  project            = var.project
  description        = var.description
  region             = var.region
  type               = var.type
  labels             = var.labels
  datafusion_version = var.datafusion_version
  options            = var.options
  network_config = {
    network       = module.data_fusion_network.data_fusion_vpc.network_name
    ip_allocation = module.data_fusion_network.data_fusion_ip_allocation
  }
}

