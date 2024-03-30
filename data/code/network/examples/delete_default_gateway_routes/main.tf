
locals {
  subnet_01 = "${var.network_name}-subnet-01"
}

module "test-vpc-module" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.0"

  project_id                             = var.project_id
  network_name                           = var.network_name
  delete_default_internet_gateway_routes = true

  subnets = [
    {
      subnet_name   = local.subnet_01
      subnet_ip     = "10.20.30.0/24"
      subnet_region = "us-west1"
    },
  ]
}
