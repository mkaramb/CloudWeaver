
module "folders" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 4.0"

  parent            = "${var.parent_type}/${var.parent_id}"
  set_roles         = true
  all_folder_admins = var.all_folder_admins

  names = [
    "dev",
    "staging",
    "production",
  ]

  per_folder_admins = {
    dev = {
      members = [
        "group:test-gcp-developers@test.blueprints.joonix.net"
      ],
    },
    staging = {
      members = [
        "group:test-gcp-qa@test.blueprints.joonix.net",
      ],
    }
    production = {
      members = [
        "group:test-gcp-ops@test.blueprints.joonix.net",
      ],
    }
  }
}

