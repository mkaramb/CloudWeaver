
output "composer_env_name" {
  description = "Name of the Cloud Composer Environment."
  value       = module.simple-composer-environment.composer_env_name
}

output "composer_env_id" {
  description = "ID of Cloud Composer Environment."
  value       = module.simple-composer-environment.composer_env_id
}

output "gke_cluster" {
  description = "Google Kubernetes Engine cluster used to run the Cloud Composer Environment."
  value       = module.simple-composer-environment.gke_cluster
}

output "gcs_bucket" {
  description = "Google Cloud Storage bucket which hosts DAGs for the Cloud Composer Environment."
  value       = module.simple-composer-environment.gcs_bucket
}

output "airflow_uri" {
  description = "URI of the Apache Airflow Web UI hosted within the Cloud Composer Environment."
  value       = module.simple-composer-environment.airflow_uri
}
