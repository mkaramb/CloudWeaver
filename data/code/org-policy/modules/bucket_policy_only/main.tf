
module "storage-uniform-bucket-level-access" {
  source           = "../../"
  policy_for       = var.policy_for
  organization_id  = var.organization_id
  folder_id        = var.folder_id
  project_id       = var.project_id
  constraint       = "constraints/storage.uniformBucketLevelAccess"
  policy_type      = "boolean"
  enforce          = true
  exclude_folders  = var.exclude_folders
  exclude_projects = var.exclude_projects
}
