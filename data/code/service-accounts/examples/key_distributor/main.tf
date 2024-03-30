
module "distributor" {
  source  = "terraform-google-modules/service-accounts/google//modules/key-distributor"
  version = "~> 4.0"

  project_id       = var.project_id
  public_key_file  = var.public_key_file
  function_members = var.cfn_members
}
