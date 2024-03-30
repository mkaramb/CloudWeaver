
module "access_context_manager_policy" {
  source  = "terraform-google-modules/vpc-service-controls/google"
  version = "~> 5.0"

  parent_id   = var.parent_id
  policy_name = var.policy_name
}

module "bridge" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/bridge_service_perimeter"
  version = "~> 5.0"

  policy         = module.access_context_manager_policy.policy_id
  perimeter_name = "bridge_perimeter_1"
  description    = "Some description"

  resources     = [module.project_one.project_number, module.project_two.project_number, module.project_three.project_number]
  resource_keys = ["one", "two", "three"]

  depends_on = [
    module.regular_service_perimeter_1,
    module.regular_service_perimeter_2
  ]
}

module "regular_service_perimeter_1" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  version = "~> 5.0"

  policy         = module.access_context_manager_policy.policy_id
  perimeter_name = "regular_perimeter_1"
  description    = "Some description"
  resources      = [module.project_one.project_number]

  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]

  shared_resources = {
    all = [module.project_one.project_number]
  }
}

module "regular_service_perimeter_2" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  version = "~> 5.0"

  policy         = module.access_context_manager_policy.policy_id
  perimeter_name = "regular_perimeter_2"
  description    = "Some description"
  resources      = [module.project_two.project_number, module.project_three.project_number]
  resource_keys  = ["two", "three"]

  restricted_services = ["storage.googleapis.com"]

  shared_resources = {
    all = [module.project_two.project_number, module.project_three.project_number]
  }
}



module "project_one" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.0"

  name              = "vpcsc-test-one"
  random_project_id = true
  org_id            = var.parent_id
  billing_account   = var.billing_account
}

module "project_two" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.0"

  name              = "vpcsc-test-two"
  random_project_id = true
  org_id            = var.parent_id
  billing_account   = var.billing_account
}

module "project_three" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.0"

  name              = "vpcsc-test-two"
  random_project_id = true
  org_id            = var.parent_id
  billing_account   = var.billing_account
}
