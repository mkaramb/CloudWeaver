
resource "random_string" "prefix" {
  length  = 4
  upper   = false
  special = false
}

module "cloud_storage" {
  source  = "terraform-google-modules/cloud-storage/google"
  version = "~> 5.0"

  project_id = var.project_id

  prefix           = "multiple-buckets-${random_string.prefix.result}"
  names            = ["one", "two"]
  randomize_suffix = true

  bucket_policy_only = {
    "one" = true
    "two" = false
  }

  folders = {
    "two" = ["dev", "prod"]
  }

  lifecycle_rules = [
    {
      action = {
        type          = "SetStorageClass"
        storage_class = "NEARLINE"
      }
      condition = {
        age                   = "10"
        matches_storage_class = "MULTI_REGIONAL,STANDARD,DURABLE_REDUCED_AVAILABILITY"
      }
    }
  ]

  bucket_lifecycle_rules = {
    "one" = [
      {
        action = {
          type = "Delete"
        }
        condition = {
          age = "90"
        }
      }
    ]
  }

  default_event_based_hold = {
    "one" = true
  }
}
