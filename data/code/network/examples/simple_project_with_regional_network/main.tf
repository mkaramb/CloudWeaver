
locals {
  subnet_01 = "${var.network_name}-subnet-01"
  subnet_02 = "${var.network_name}-subnet-02"
}

module "test-vpc-module" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.0"

  project_id   = var.project_id
  network_name = var.network_name
  routing_mode = "REGIONAL"

  subnets = [
    {
      subnet_name   = local.subnet_01
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "us-west1"
    },
    {
      subnet_name           = local.subnet_02
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
  ]
}
