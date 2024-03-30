
module "memstore" {
  source  = "terraform-google-modules/memorystore/google"
  version = "~> 8.0"

  name               = "test-minimal"
  project            = var.project_id
  region             = "us-east1"
  location_id        = "us-east1-b"
  enable_apis        = true
  tier               = "BASIC"
  authorized_network = module.test-vpc-module.network_id

  memory_size_gb = 1
}



module "test-vpc-module" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 9.0"
  project_id   = var.project_id
  network_name = "test-net-minimal"
  mtu          = 1460

  subnets = [
    {
      subnet_name   = "subnet-02"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "us-east1"
    },
  ]
}
