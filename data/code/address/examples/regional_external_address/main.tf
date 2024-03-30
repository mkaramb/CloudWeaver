
# [START compute_external_ip_create]
module "address" {
  source       = "terraform-google-modules/address/google"
  version      = "~> 3.1"
  project_id   = var.project_id # Replace this with your service project ID in quotes
  region       = "europe-west1"
  address_type = "EXTERNAL"
  names = [
    "regional-external-ip-address-1",
    "regional-external-ip-address-2",
    "regional-external-ip-address-3"
  ]
}
# [END compute_external_ip_create]

