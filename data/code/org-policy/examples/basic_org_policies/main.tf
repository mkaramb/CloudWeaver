
module "domain-restricted-sharing" {
  source  = "terraform-google-modules/org-policy/google//modules/domain_restricted_sharing"
  version = "~> 5.0"

  policy_for       = "organization"
  organization_id  = var.organization_id
  domains_to_allow = var.domains_to_allow
}

module "skip-default-network" {
  source  = "terraform-google-modules/org-policy/google//modules/skip_default_network"
  version = "~> 5.0"

  policy_for      = "organization"
  organization_id = var.organization_id
}

module "bucket-policy-only" {
  source  = "terraform-google-modules/org-policy/google//modules/bucket_policy_only"
  version = "~> 5.0"

  policy_for      = "organization"
  organization_id = var.organization_id
}

module "restrict-vm-external-ips" {
  source  = "terraform-google-modules/org-policy/google//modules/restrict_vm_external_ips"
  version = "~> 5.0"

  policy_for      = "organization"
  organization_id = var.organization_id
  vms_to_allow    = var.vms_to_allow
}
