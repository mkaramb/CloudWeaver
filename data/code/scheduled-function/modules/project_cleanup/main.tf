
locals {
  target_included_labels = var.target_tag_name != "" && var.target_tag_value != "" ? merge({ var.target_tag_name = var.target_tag_value }, var.target_included_labels) : var.target_included_labels
}

resource "google_service_account" "project_cleaner_function" {
  project      = var.project_id
  account_id   = "project-cleaner-function"
  display_name = "Project Cleaner Function"
}

resource "google_organization_iam_member" "main" {
  for_each = toset([
    "roles/resourcemanager.projectDeleter",
    "roles/resourcemanager.folderEditor",
    "roles/resourcemanager.lienModifier",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/compute.orgSecurityResourceAdmin",
    "roles/compute.orgSecurityPolicyAdmin",
    "roles/resourcemanager.tagAdmin",
    "roles/viewer"
  ])

  member = "serviceAccount:${google_service_account.project_cleaner_function.email}"
  org_id = var.organization_id
  role   = each.value
}

module "scheduled_project_cleaner" {
  source                         = "../.."
  project_id                     = var.project_id
  job_name                       = "project-cleaner"
  job_schedule                   = var.job_schedule
  function_entry_point           = "CleanUpProjects"
  function_source_directory      = "${path.module}/function_source"
  function_name                  = "old-project-cleaner"
  region                         = var.region
  topic_name                     = var.topic_name
  function_available_memory_mb   = 128
  function_description           = "Clean up GCP projects older than ${var.max_project_age_in_hours} hours matching particular tags"
  function_runtime               = "go121"
  function_service_account_email = google_service_account.project_cleaner_function.email
  function_timeout_s             = var.function_timeout_s

  function_environment_variables = {
    TARGET_ORGANIZATION_ID  = var.organization_id
    TARGET_FOLDER_ID        = var.target_folder_id
    TARGET_EXCLUDED_LABELS  = jsonencode(var.target_excluded_labels)
    TARGET_INCLUDED_LABELS  = jsonencode(local.target_included_labels)
    MAX_PROJECT_AGE_HOURS   = var.max_project_age_in_hours
    CLEAN_UP_TAG_KEYS       = var.clean_up_org_level_tag_keys
    TARGET_EXCLUDED_TAGKEYS = jsonencode(var.target_excluded_tagkeys)
  }
}