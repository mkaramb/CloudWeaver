
module "access_context_manager_policy" {
  source  = "terraform-google-modules/vpc-service-controls/google"
  version = "~> 5.0"

  parent_id   = var.parent_id
  policy_name = var.policy_name
}

module "access_level_members" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  version = "~> 5.0"

  description = "Simple Example Access Level"
  policy      = module.access_context_manager_policy.policy_id
  name        = var.access_level_name
  members     = var.members
  regions     = var.regions
}

resource "null_resource" "wait_for_members" {
  provisioner "local-exec" {
    command = "sleep 60"
  }

  depends_on = [module.access_level_members]
}

module "regular_service_perimeter_1" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  version = "~> 5.0"

  policy         = module.access_context_manager_policy.policy_id
  perimeter_name = var.perimeter_name

  description   = "Perimeter shielding bigquery project"
  resources     = [var.protected_project_ids["number"]]
  access_levels = [module.access_level_members.name]

  restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]

  ingress_policies = [
    {
      "from" = {
        "sources" = {
          access_levels = ["*"] # Allow Access from everywhere
        },
        "identities" = var.read_bucket_identities
      }
      "to" = {
        "resources" = [
          "*"
        ]
        "operations" = {
          "storage.googleapis.com" = {
            "methods" = [
              "google.storage.objects.get",
              "google.storage.objects.list"
            ]
          }
        }
      }
    },
  ]

  shared_resources = {
    all = [var.protected_project_ids["number"]]
  }

  depends_on = [
    module.gcs_buckets
  ]
}


module "gcs_buckets" {
  source           = "terraform-google-modules/cloud-storage/google"
  version          = "~> 5.0"
  project_id       = var.protected_project_ids["id"]
  names            = var.buckets_names
  randomize_suffix = true
  prefix           = var.buckets_prefix
  set_admin_roles  = true
  admins           = var.members
}
