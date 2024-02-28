# Google Cloud Documentation: https://cloud.google.com/iam/docs/deny-access#create-deny-policy
# Hashicorp Documentation: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_deny_policy

/*
Create all service agents for aiplatform.googleapis.com for
the `default` project, then grant roles to the service agents.
*/

# [START iam_create_service_agent_parent_tag]
# [START iam_create_project_level_service_agent]
data "google_project" "default" {
}

# Create all project-level aiplatform.googleapis.com service agents
resource "google_project_service_identity" "default" {
  provider = google-beta

  project = data.google_project.default.project_id
  service = "aiplatform.googleapis.com"
}
# [END iam_create_project_level_service_agent]

# [START iam_grant_roles_to_service_agents]
# Grant the AI Platform Custom Code Service Account the Vertex AI Custom
# Code Service Agent role (roles/aiplatform.customCodeServiceAgent)
resource "google_project_iam_member" "custom_code" {
  project = data.google_project.default.project_id
  role    = "roles/aiplatform.customCodeServiceAgent"
  member  = "serviceAccount:service-${data.google_project.default.number}@gcp-sa-aiplatform-cc.iam.gserviceaccount.com"
}

# Grant the primary aiplatform.googleapis.com service agent (AI Platform
# Service Agent) the Vertex AI Service Agent role
# (roles/aiplatform.serviceAgent)
resource "google_project_iam_member" "primary" {
  project = data.google_project.default.project_id
  role    = "roles/aiplatform.serviceAgent"
  member  = "serviceAccount:${google_project_service_identity.default.email}"
}
# [END iam_grant_roles_to_service_agents]
# [END iam_create_service_agent_parent_tag]
