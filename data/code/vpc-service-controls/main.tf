
resource "google_access_context_manager_access_policy" "access_policy" {
  provider = google
  parent   = "organizations/${var.parent_id}"
  title    = var.policy_name
}
