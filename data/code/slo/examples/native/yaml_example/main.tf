
locals {
  slo_configs = [
    for file in fileset(path.module, "/templates/*.yaml") :
    yamldecode(templatefile(file,
      {
        project_id            = var.project_id,
        app_engine_service_id = data.google_monitoring_app_engine_service.default.service_id,
        service_id            = google_monitoring_custom_service.customsrv.service_id,
    }))
  ]
  slo_config_map = { for config in local.slo_configs : config.slo_id => config }
}

module "slo-cass-latency5ms-window" {
  source  = "terraform-google-modules/slo/google//modules/slo-native"
  version = "~> 3.0"

  config = local.slo_config_map["cass-latency5ms-window"]
}

module "slo-gae-latency500ms" {
  source  = "terraform-google-modules/slo/google//modules/slo-native"
  version = "~> 3.0"

  config = local.slo_config_map["gae-latency500ms"]
}

module "slo-gcp-latency400ms" {
  source  = "terraform-google-modules/slo/google//modules/slo-native"
  version = "~> 3.0"

  config = local.slo_config_map["gcp-latency400ms"]
}

module "slo-gcp-latency500ms-window" {
  source  = "terraform-google-modules/slo/google//modules/slo-native"
  version = "~> 3.0"

  config = local.slo_config_map["gcp-latency500ms-window"]
}

module "slo-uptime-latency500ms-window" {
  source  = "terraform-google-modules/slo/google//modules/slo-native"
  version = "~> 3.0"

  config = local.slo_config_map["uptime-latency500ms-window"]
}

module "slo-uptime-pass-window" {
  source  = "terraform-google-modules/slo/google//modules/slo-native"
  version = "~> 3.0"

  config = local.slo_config_map["uptime-pass-window"]
}


data "google_monitoring_app_engine_service" "default" {
  project   = var.app_engine_project_id
  module_id = "default"
}

resource "google_monitoring_custom_service" "customsrv" {
  project      = var.project_id
  service_id   = "custom-srv-request-slos"
  display_name = "My Custom Service"
}
