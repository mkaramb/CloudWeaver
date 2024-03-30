
####################
# Instance Templates
####################

module "preemptible" {
  source               = "../../modules/instance_template"
  name_prefix          = "${var.name_prefix}-preemptible"
  project_id           = var.project_id
  machine_type         = var.machine_type
  labels               = var.labels
  metadata             = var.metadata
  tags                 = var.tags
  can_ip_forward       = var.can_ip_forward
  startup_script       = var.startup_script
  source_image         = var.source_image
  source_image_project = var.source_image_project
  source_image_family  = var.source_image_family
  disk_size_gb         = var.disk_size_gb
  disk_type            = var.disk_type
  auto_delete          = var.auto_delete
  additional_disks     = var.additional_disks
  service_account      = var.service_account
  network              = var.network
  subnetwork           = var.subnetwork
  subnetwork_project   = var.subnetwork_project
  access_config        = var.access_config
  ipv6_access_config   = var.ipv6_access_config
  preemptible          = true
}

module "regular" {
  source               = "../../modules/instance_template"
  name_prefix          = "${var.name_prefix}-regular"
  project_id           = var.project_id
  machine_type         = var.machine_type
  labels               = var.labels
  metadata             = var.metadata
  tags                 = var.tags
  can_ip_forward       = var.can_ip_forward
  startup_script       = var.startup_script
  source_image         = var.source_image
  source_image_project = var.source_image_project
  source_image_family  = var.source_image_family
  disk_size_gb         = var.disk_size_gb
  disk_type            = var.disk_type
  auto_delete          = var.auto_delete
  additional_disks     = var.additional_disks
  service_account      = var.service_account
  network              = var.network
  subnetwork           = var.subnetwork
  subnetwork_project   = var.subnetwork_project
  access_config        = var.access_config
  ipv6_access_config   = var.ipv6_access_config
  preemptible          = false
}
