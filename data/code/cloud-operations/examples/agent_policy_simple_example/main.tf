
module "agent_policy_simple" {
  source  = "terraform-google-modules/cloud-operations/google//modules/agent-policy"
  version = "~> 0.4"

  project_id = var.project_id
  policy_id  = "ops-agents-test-policy-simple"
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
      env = "prod"
      app = "myproduct"
    }
  ]
  os_types = [
    {
      short_name = "centos"
      version    = "8"
    },
  ]
}
