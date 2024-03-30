
provider "google" {
  region = var.region
}

module "address" {
  source  = "terraform-google-modules/address/google"
  version = "~> 3.0"

  project_id = var.project_id
  region     = var.region
  subnetwork = var.subnetwork
  names      = var.names
  addresses  = var.addresses
}

