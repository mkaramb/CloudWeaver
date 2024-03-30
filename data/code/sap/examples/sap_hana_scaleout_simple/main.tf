
module "hana_scaleout" {
  source  = "terraform-google-modules/sap/google//modules/sap_hana_scaleout"
  version = "~> 1.0"

  project_id          = var.project_id
  zone                = "us-east1-b"
  machine_type        = "n1-standard-16"
  subnetwork          = "default"
  linux_image         = "rhel-8-4-sap-ha"
  linux_image_project = "rhel-sap-cloud"
  instance_name       = "hana-instance-scaleout"
  sap_hana_sid        = "ABC"
  sap_hana_shared_nfs = "10.128.0.100:/shared"
  sap_hana_backup_nfs = "10.128.0.101:/backup"
}
