
module "agent_policy_update" {
  source  = "terraform-google-modules/cloud-operations/google//modules/agent-policy"
  version = "~> 0.4"

  project_id   = var.project_id
  policy_id    = "ops-agents-test-policy-update"
  description  = var.description
  agent_rules  = var.agent_rules
  group_labels = var.group_labels
  os_types     = var.os_types
  zones        = var.zones
  instances    = var.instances
}
