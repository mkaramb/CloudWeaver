
locals {
  net_data_users = compact(concat(
    var.service_project_owners,
    ["serviceAccount:${var.service_project_number}@cloudservices.gserviceaccount.com"]
  ))
}

module "net-vpc-shared" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.0"

  project_id      = var.host_project_id
  network_name    = var.network_name
  shared_vpc_host = true

  subnets = [
    {
      subnet_name   = "networking"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "europe-west1"
    },
    {
      subnet_name   = "data"
      subnet_ip     = "10.10.20.0/24"
      subnet_region = "europe-west1"
    },
  ]
}

module "net-svpc-access" {
  source  = "terraform-google-modules/network/google//modules/fabric-net-svpc-access"
  version = "~> 9.0"

  host_project_id     = module.net-vpc-shared.project_id
  service_project_ids = [var.service_project_id]
  host_subnets        = ["data"]
  host_subnet_regions = ["europe-west1"]
  host_subnet_users = {
    data = join(",", local.net_data_users)
  }
}
