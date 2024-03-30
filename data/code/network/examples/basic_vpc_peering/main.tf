
# Whenever a new major version of the network module is released, the
# version constraint below should be updated, e.g. to ~> 4.0.
#
# If that new version includes provider updates, validation of this
# example may fail until that is done.

# [START vpc_peering_create]
module "peering1" {
  source        = "terraform-google-modules/network/google//modules/network-peering"
  version       = "~> 9.0"
  local_network = var.local_network # Replace with self link to VPC network "foobar" in quotes
  peer_network  = var.peer_network  # Replace with self link to VPC network "other" in quotes
}
# [END vpc_peering_create]
