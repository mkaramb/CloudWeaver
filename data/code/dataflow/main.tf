
resource "google_dataflow_job" "dataflow_job" {
  project                = var.project_id
  region                 = var.region
  zone                   = var.zone
  name                   = var.name
  on_delete              = var.on_delete
  max_workers            = var.max_workers
  template_gcs_path      = var.template_gcs_path
  temp_gcs_location      = "gs://${var.temp_gcs_location}/tmp_dir"
  parameters             = var.parameters
  service_account_email  = var.service_account_email
  network                = var.network_self_link
  subnetwork             = var.subnetwork_self_link
  machine_type           = var.machine_type
  ip_configuration       = var.ip_configuration
  additional_experiments = var.additional_experiments
  kms_key_name           = var.kms_key_name
  labels                 = var.labels
}

