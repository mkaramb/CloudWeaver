
resource "random_id" "rand_custom_id" {
  byte_length = 2
}

/******************************************
  Module custom_role call
 *****************************************/
module "custom-roles-org" {
  source  = "terraform-google-modules/iam/google//modules/custom_role_iam"
  version = "~> 7.0"

  target_level         = "org"
  target_id            = var.org_id
  role_id              = "iamDeleter_${random_id.rand_custom_id.hex}"
  base_roles           = ["roles/iam.serviceAccountAdmin"]
  permissions          = ["iam.roles.list", "iam.roles.create", "iam.roles.delete"]
  excluded_permissions = ["iam.serviceAccounts.setIamPolicy"]
  description          = "This is an organization level custom role."
  members              = ["group:test-gcp-org-admins@test.blueprints.joonix.net", "group:test-gcp-billing-admins@test.blueprints.joonix.net"]
}
