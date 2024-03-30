
module "memorystore" {
  source  = "terraform-google-modules/memorystore/google"
  version = "~> 8.0"

  name           = "memorystore"
  project        = "memorystore"
  memory_size_gb = "1"
  enable_apis    = "true"
}
