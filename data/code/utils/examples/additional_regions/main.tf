
module "utils" {
  source  = "terraform-google-modules/utils/google"
  version = "~> 0.7"

  additional_regions = ["us-central2"]
  region             = "us-central2"
}
