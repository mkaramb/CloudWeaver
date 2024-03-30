
provider "google" {

  project = var.project_id
  region  = var.region
}

module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 11.0"

  project_id      = var.project_id
  subnetwork      = var.subnetwork
  service_account = var.service_account
  name_prefix     = "additional-disks"

  additional_disks = [
    {
      disk_name    = "disk-0"
      device_name  = "disk-0"
      disk_size_gb = 10
      disk_type    = "pd-standard"
      auto_delete  = "true"
      boot         = "false"
      disk_labels  = {}
    },
    {
      disk_name    = "disk-1"
      device_name  = "disk-1"
      disk_size_gb = 10
      disk_type    = "pd-standard"
      auto_delete  = "true"
      boot         = "false"
      disk_labels  = { "foo" : "bar" }
    },
    {
      disk_name    = "disk-2"
      device_name  = "disk-2"
      disk_size_gb = 10
      disk_type    = "pd-standard"
      auto_delete  = "true"
      boot         = "false"
      disk_labels  = { "foo" : "bar" }
    },
  ]
}
