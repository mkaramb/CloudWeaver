
locals {
  network_name = "${var.network_name}-basic"
  subnet_name  = "${local.network_name}-subnet"
  subnet_ip    = "10.10.10.0/24"
}

/******************************************
  Create VPC
 *****************************************/
module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 9.0"
  project_id   = var.project_id
  network_name = local.network_name

  subnets = [
    {
      subnet_name   = local.subnet_name
      subnet_ip     = local.subnet_ip
      subnet_region = var.region
    },
  ]

  secondary_ranges = {
    "local.subnet_name" = []
  }
}

/******************************************
  Adding Cloud Router
 *****************************************/

resource "google_compute_router" "main" {
  name    = "${module.vpc.network_name}-router"
  project = var.project_id
  region  = var.region
  network = module.vpc.network_self_link

  bgp {
    asn = 64514
  }
}

/******************************************
  Adding Cloud NAT
 *****************************************/
resource "google_compute_router_nat" "main" {
  name                               = "${module.vpc.network_name}-nat"
  router                             = google_compute_router.main.name
  project                            = var.project_id
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = module.vpc.subnets_self_links[0]
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

}

/******************************************
  Create a default Datalab instance
 *****************************************/
module "datalab" {
  source             = "terraform-google-modules/datalab/google//modules/instance"
  version            = "~> 2.0"
  project_id         = var.project_id
  name               = var.name
  zone               = var.zone
  datalab_user_email = var.datalab_user_email
  network_name       = module.vpc.network_name
  subnet_name        = module.vpc.subnets_self_links[0]
  create_fw_rule     = var.create_fw_rule
  service_account    = var.service_account
  labels             = var.labels
  enable_secure_boot = var.enable_secure_boot
}
