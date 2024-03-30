
data "google_projects" "in_perimeter_folder" {
  filter = "parent.id:${var.folder_id}"
}

data "google_project" "in_perimeter_folder" {
  count = length(data.google_projects.in_perimeter_folder.projects)

  project_id = data.google_projects.in_perimeter_folder.projects[count.index].project_id
}

locals {
  projects     = compact(data.google_project.in_perimeter_folder[*].number)
  parent_id    = var.org_id
  watcher_name = replace("${var.policy_name}-manager", "_", "-")
}

module "access_context_manager_policy" {
  source  = "terraform-google-modules/vpc-service-controls/google"
  version = "~> 5.0"

  parent_id   = local.parent_id
  policy_name = var.policy_name
}

module "access_level_members" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  version = "~> 5.0"

  description = "${var.perimeter_name} Access Level"
  policy      = module.access_context_manager_policy.policy_id
  name        = "${var.perimeter_name}_members"
  members     = var.members
}

module "service_perimeter" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  version = "~> 5.0"

  policy         = module.access_context_manager_policy.policy_id
  perimeter_name = var.perimeter_name

  description = "Perimeter ${var.perimeter_name}"
  resources   = local.projects

  access_levels       = [module.access_level_members.name]
  restricted_services = var.restricted_services

  shared_resources = {
    all = local.projects
  }
}
