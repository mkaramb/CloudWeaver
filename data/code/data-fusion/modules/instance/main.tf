
resource "google_data_fusion_instance" "instance" {
  provider                      = google-beta
  name                          = var.name
  project                       = var.project
  description                   = var.description
  region                        = var.region
  type                          = var.type
  enable_stackdriver_logging    = true
  enable_stackdriver_monitoring = true
  labels                        = var.labels
  version                       = var.datafusion_version
  options                       = var.options
  private_instance              = var.network_config != null

  dynamic "network_config" {
    for_each = var.network_config == null ? [] : [var.network_config]
    content {
      network       = var.network_config.network
      ip_allocation = var.network_config.ip_allocation
    }
  }
}
