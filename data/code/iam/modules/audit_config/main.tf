
locals {
  audit_log_config = {
    for key, val in var.audit_log_config :
    val.service => val...
  }
}

resource "google_project_iam_audit_config" "project" {
  for_each = local.audit_log_config
  project  = var.project
  service  = each.key

  dynamic "audit_log_config" {
    for_each = each.value
    iterator = log_type
    content {
      log_type         = log_type.value.log_type
      exempted_members = log_type.value.exempted_members
    }
  }
}
