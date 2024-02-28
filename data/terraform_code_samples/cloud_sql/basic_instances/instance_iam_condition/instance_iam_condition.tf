# Allow users to connect to specific Cloud SQL instances

data "google_project" "project" {
}

resource "google_project_service_identity" "gcp_sa_cloud_sql" {
  provider = google-beta
  service  = "sqladmin.googleapis.com"
}

# [START cloud_sql_instance_iam_conditions]
data "google_iam_policy" "sql_iam_policy" {
  binding {
    role = "roles/cloudsql.client"
    members = [
      "serviceAccount:${google_project_service_identity.gcp_sa_cloud_sql.email}",
    ]
    condition {
      expression  = "resource.name == 'projects/${data.google_project.project.project_id}/instances/${google_sql_database_instance.default.name}' && resource.type == 'sqladmin.googleapis.com/Instance'"
      title       = "created"
      description = "Cloud SQL instance creation"
    }
  }
}

resource "google_project_iam_policy" "project" {
  project     = data.google_project.project.project_id
  policy_data = data.google_iam_policy.sql_iam_policy.policy_data
}
# [END cloud_sql_instance_iam_conditions]

resource "google_sql_database_instance" "default" {
  name             = "mysql-instance-iam-condition"
  provider         = google-beta
  region           = "us-central1"
  database_version = "MYSQL_8_0"
  settings {
    tier = "db-n1-standard-2"
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}
