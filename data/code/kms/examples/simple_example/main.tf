
module "kms" {
  source  = "terraform-google-modules/kms/google"
  version = "~> 2.0"

  project_id = var.project_id
  keyring    = var.keyring
  location   = var.location
  keys       = var.keys
  # keys can be destroyed by Terraform
  prevent_destroy = false
}

