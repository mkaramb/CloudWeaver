
module "sap_hana" {
  source  = "terraform-google-modules/sap/google//modules/sap_hana"
  version = "~> 1.0"

  project_id          = var.project_id
  machine_type        = "n1-standard-16"
  subnetwork          = "default"
  linux_image         = "rhel-8-4-sap-ha"
  linux_image_project = "rhel-sap-cloud"
  instance_name       = "hana-instance"
  zone                = "us-east1-b"
  sap_hana_sid        = "XYZ"
}
