
module "access_context_manager_policy" {
  source  = "terraform-google-modules/vpc-service-controls/google"
  version = "~> 5.0"

  parent_id   = var.parent_id
  policy_name = var.policy_name
}

module "bridge_service_perimeter_1" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/bridge_service_perimeter"
  version = "~> 5.0"

  policy         = module.access_context_manager_policy.policy_id
  perimeter_name = "bridge_perimeter_1"
  description    = "Some description"

  resources = concat(
    module.regular_service_perimeter_1.shared_resources["all"],
    module.regular_service_perimeter_2.shared_resources["all"],
  )
}

module "regular_service_perimeter_1" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  version = "~> 5.0"

  policy         = module.access_context_manager_policy.policy_id
  perimeter_name = "regular_perimeter_1"
  description    = "Some description"
  resources      = [var.protected_project_ids["number"]]

  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]

  shared_resources = {
    all = [var.protected_project_ids["number"]]
  }
}

module "regular_service_perimeter_2" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  version = "~> 5.0"

  policy         = module.access_context_manager_policy.policy_id
  perimeter_name = "regular_perimeter_2"
  description    = "Some description"
  resources      = [var.public_project_ids["number"]]

  restricted_services = ["storage.googleapis.com"]

  shared_resources = {
    all = [var.public_project_ids["number"]]
  }
}
