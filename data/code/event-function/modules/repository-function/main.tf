
resource "google_cloudfunctions_function" "main" {
  name                          = var.name
  description                   = var.description
  available_memory_mb           = var.available_memory_mb
  max_instances                 = var.max_instances
  timeout                       = var.timeout_s
  entry_point                   = var.entry_point
  ingress_settings              = var.ingress_settings
  trigger_http                  = var.trigger_http
  vpc_connector_egress_settings = var.vpc_connector_egress_settings
  vpc_connector                 = var.vpc_connector

  dynamic "event_trigger" {
    for_each = var.trigger_http != null ? [] : [1]

    content {
      event_type = var.event_trigger["event_type"]
      resource   = var.event_trigger["resource"]

      failure_policy {
        retry = var.event_trigger_failure_policy_retry
      }
    }
  }

  labels                = var.labels
  runtime               = var.runtime
  environment_variables = var.environment_variables

  source_repository {
    url = var.source_repository_url
  }

  project               = var.project_id
  region                = var.region
  service_account_email = var.service_account_email

  timeouts {
    create = lookup(var.timeouts, "create", "5m")
    update = lookup(var.timeouts, "update", "5m")
    delete = lookup(var.timeouts, "delete", "5m")
  }
}
