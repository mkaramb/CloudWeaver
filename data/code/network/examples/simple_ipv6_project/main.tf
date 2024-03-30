
# Whenever a new major version of the network module is released, the
# version constraint below should be updated, e.g. to ~> 4.0.
#
# If that new version includes provider updates, validation of this
# example may fail until that is done.

# [START vpc_custom_create]
module "test-vpc-module" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.0"

  project_id   = var.project_id # Replace this with your project ID in quotes
  network_name = "my-custom-mode-network"
  mtu          = 1460

  subnets = [
    {
      subnet_name      = "subnet-01"
      subnet_ip        = "10.10.10.0/24"
      subnet_region    = "us-west1"
      stack_type       = "IPV4_IPV6"
      ipv6_access_type = "EXTERNAL"
    },
    {
      subnet_name           = "subnet-02"
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name               = "subnet-03"
      subnet_ip                 = "10.10.30.0/24"
      subnet_region             = "us-west1"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_filter   = "false"
    }
  ]
}
# [END vpc_custom_create]
