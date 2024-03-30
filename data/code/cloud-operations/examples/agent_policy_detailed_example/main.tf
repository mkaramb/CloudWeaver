
module "agent_policy_detailed" {
  source  = "terraform-google-modules/cloud-operations/google//modules/agent-policy"
  version = "~> 0.4"

  project_id  = var.project_id
  policy_id   = "ops-agents-test-policy-detailed"
  description = "an example policy description"
  agent_rules = [
    {
      type               = "logging"
      version            = "current-major"
      package_state      = "installed"
      enable_autoupgrade = true
    },
    {
      type               = "metrics"
      version            = "current-major"
      package_state      = "installed"
      enable_autoupgrade = true
    },
  ]
  group_labels = [
    {
      env     = "prod"
      product = "myapp"
    },
    {
      env     = "staging"
      product = "myapp"
    }
  ]
  os_types = [
    {
      short_name = "debian"
      version    = "10"
    },
  ]
  zones = [
    "us-central1-c",
    "asia-northeast2-b",
    "europe-north1-b",
  ]
  instances = ["zones/us-central1-a/instances/test-instance"]
}
