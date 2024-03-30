
module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 6.0"

  name    = "example-router"
  project = "example-project"
  network = "default"
  region  = "us-central1"

  bgp = {
    asn               = 65000
    advertised_groups = ["ALL_SUBNETS"]
  }
}

module "interconnect_attachment" {
  source  = "terraform-google-modules/cloud-router/google//modules/interconnect_attachment"
  version = "~> 6.0"

  name    = "example-attachment"
  project = "example-project"
  region  = "us-central1"
  router  = module.cloud_router.router.name

  interconnect = "https://googleapis.com/interconnects/example-interconnect"

  interface = {
    name = "example-interface"
  }

  peer = {
    name            = "example-peer"
    peer_ip_address = "169.254.1.2"
    peer_asn        = 65001
  }
}
