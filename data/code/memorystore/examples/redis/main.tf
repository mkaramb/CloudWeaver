
module "memstore" {
  source  = "terraform-google-modules/memorystore/google"
  version = "~> 8.0"

  name = "test-redis"

  project                 = var.project_id
  region                  = "us-east1"
  location_id             = "us-east1-b"
  alternative_location_id = "us-east1-d"
  enable_apis             = true
  auth_enabled            = true
  transit_encryption_mode = "SERVER_AUTHENTICATION"
  authorized_network      = module.test-vpc-module.network_id
  memory_size_gb          = 1
  persistence_config = {
    persistence_mode    = "RDB"
    rdb_snapshot_period = "ONE_HOUR"
  }
}



module "test-vpc-module" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 9.0"
  project_id   = var.project_id
  network_name = "test-net-redis"
  mtu          = 1460

  subnets = [
    {
      subnet_name   = "subnet-03"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "us-east1"
    },
  ]
}
