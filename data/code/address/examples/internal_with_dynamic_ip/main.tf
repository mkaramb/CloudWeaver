
# [START compute_internal_ip_create]
module "address" {
  source     = "terraform-google-modules/address/google"
  version    = "~> 3.1"
  project_id = var.project_id # Replace this with your project ID in quotes
  region     = "asia-east1"
  subnetwork = "my-subnet"
  names      = ["internal-address1", "internal-address2"]
}
# [END compute_internal_ip_create]
