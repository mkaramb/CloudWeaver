
module "sap_hana_ha" {
  source  = "terraform-google-modules/sap/google//modules/sap_hana_ha"
  version = "~> 1.0"

  project_id              = var.project_id
  machine_type            = "n1-standard-16"
  network                 = "default"
  subnetwork              = "default"
  linux_image             = "rhel-8-4-sap-ha"
  linux_image_project     = "rhel-sap-cloud"
  primary_instance_name   = "hana-ha-primary"
  primary_zone            = "us-east1-b"
  secondary_instance_name = "hana-ha-secondary"
  secondary_zone          = "us-east1-c"
}
