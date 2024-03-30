
module "private-service-access" {
  source      = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  version     = "~> 18.0"
  project_id  = var.project_id
  vpc_network = module.test-vpc-module.network_name
  depends_on = [
    module.test-vpc-module
  ]
}

module "memcache" {
  source  = "terraform-google-modules/memorystore/google//modules/memcache"
  version = "~> 8.0"

  name               = "example-memcache"
  project            = var.project_id
  memory_size_mb     = "1024"
  enable_apis        = true
  cpu_count          = "1"
  region             = "us-east1"
  authorized_network = module.test-vpc-module.network_id
  maintenance_policy = {
    day      = "MONDAY"
    duration = "10800s"
    start_time = {
      hours   = 8
      minutes = 0
      seconds = 0
      nanos   = 0
    }
  }
  depends_on = [
    module.private-service-access.peering_completed
  ]
}



module "test-vpc-module" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 9.0"
  project_id   = var.project_id
  network_name = "test-net"
  mtu          = 1460

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "us-east1"
    },
  ]
}
