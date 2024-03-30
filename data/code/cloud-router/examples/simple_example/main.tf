
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.0"

  project_id   = var.project_id
  network_name = "test-network"
  routing_mode = "GLOBAL"
  subnets      = []
}


# [START cloudrouter_create]
module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 6.0"

  name   = "my-router"
  region = "us-central1"

  bgp = {
    # The ASN (16550, 64512 - 65534, 4200000000 - 4294967294) can be any private ASN
    # not already used as a peer ASN in the same region and network or 16550 for Partner Interconnect.
    asn = "65001"
  }

  project = var.project_id
  network = module.vpc.network_name
}
# [END cloudrouter_create]
