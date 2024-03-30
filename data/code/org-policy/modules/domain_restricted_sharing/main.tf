
data "google_organization" "orgs" {
  for_each = toset(var.domains_to_allow)
  domain   = each.value
}

module "allowed-policy-member-domains" {
  source            = "../../"
  policy_for        = var.policy_for
  organization_id   = var.organization_id
  folder_id         = var.folder_id
  project_id        = var.project_id
  constraint        = "constraints/iam.allowedPolicyMemberDomains"
  policy_type       = "list"
  allow             = [for org in data.google_organization.orgs : org["directory_customer_id"]]
  allow_list_length = length(var.domains_to_allow)
  exclude_folders   = var.exclude_folders
  exclude_projects  = var.exclude_projects
}
