
/********************************************************
  Apply the sample constraint using the org_policy_v2 module
 *******************************************************/
module "gcp_org_policy_v2" {
  source  = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version = "~> 5.0"

  policy_root    = "organization"
  policy_root_id = var.org_id
  rules = [{
    enforcement = true
    allow       = []
    deny        = []
    conditions  = []
  }]
  constraint  = "compute.requireOsLogin"
  policy_type = "boolean"
}
