
module "bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 5.0"

  name       = "${var.project_id}-bucket"
  project_id = var.project_id
  location   = "us"

  lifecycle_rules = [{
    action = {
      type = "Delete"
    }
    condition = {
      age            = 365
      with_state     = "ANY"
      matches_prefix = var.project_id
    }
  }]

  custom_placement_config = {
    data_locations : ["US-EAST4", "US-WEST1"]
  }

  iam_members = [{
    role   = "roles/storage.objectViewer"
    member = "group:test-gcp-ops@test.blueprints.joonix.net"
  }]

  autoclass = true
}
