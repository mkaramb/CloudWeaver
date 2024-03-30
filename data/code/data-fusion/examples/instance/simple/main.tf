
module "data_fusion" {
  source  = "terraform-google-modules/data-fusion/google"
  version = "~> 3.0"

  name    = "example-instance"
  project = var.project_id
  region  = "us-central1"
  network = "default"
}
