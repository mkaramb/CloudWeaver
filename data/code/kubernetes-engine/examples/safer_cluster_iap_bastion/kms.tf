
module "kms" {
  source          = "terraform-google-modules/kms/google"
  version         = "~> 2.3"
  project_id      = var.project_id
  location        = var.region
  keyring         = "gke-keyring"
  keys            = ["gke-key"]
  prevent_destroy = false
}
