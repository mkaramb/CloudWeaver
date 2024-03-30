
module "compute-vm-external-ip-access" {
  source            = "../../"
  policy_for        = var.policy_for
  organization_id   = var.organization_id
  folder_id         = var.folder_id
  project_id        = var.project_id
  constraint        = "constraints/compute.vmExternalIpAccess"
  policy_type       = "list"
  allow             = var.vms_to_allow
  allow_list_length = length(var.vms_to_allow)
  exclude_folders   = var.exclude_folders
  exclude_projects  = var.exclude_projects
}
