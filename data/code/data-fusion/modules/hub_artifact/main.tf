
locals {
  package_version = var.package_version != null ? var.package_version : var.artifact_version
  gcs_path        = "gs://${var.bucket}/packages/${var.package}/${local.package_version}/${var.name}-${var.artifact_version}"
}

resource "cdap_gcs_artifact" "artifact" {
  name             = var.name
  version          = var.artifact_version
  namespace        = var.namespace
  jar_binary_path  = "${local.gcs_path}.jar"
  json_config_path = "${local.gcs_path}.json"
}
