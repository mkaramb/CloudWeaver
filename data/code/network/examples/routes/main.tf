
# Whenever a new major version of the network module is released, the
# version constraint below should be updated, e.g. to ~> 4.0.
#
# If that new version includes provider updates, validation of this
# example may fail until that is done.

# [START vpc_static_route_create]
module "google_compute_route" {
  source       = "terraform-google-modules/network/google//modules/routes"
  version      = "~> 9.0"
  project_id   = var.project_id # Replace this with your project ID in quotes
  network_name = "default"

  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    }
  ]
}
# [END vpc_static_route_create]
