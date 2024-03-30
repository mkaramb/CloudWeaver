
locals {
  export_filter   = var.export_filter != "" ? var.export_filter : data.external.compute_filter.result.filter
  machine_project = var.machine_project != "" ? var.machine_project : var.project_id
}

#------#
# Data #
#------#
data "external" "compute_filter" {
  program = [
    "python",
    "${path.module}/scripts/get_logsink_filter.py",
    var.project_id,
    join(" ", var.applications)
  ]
}

data "template_file" "gsuite_exporter" {
  template = file("${path.module}/scripts/gsuite_exporter.sh.tpl")

  vars = {
    admin_user              = var.admin_user
    api                     = var.api
    applications            = join(" ", var.applications)
    project_id              = var.project_id
    frequency               = var.frequency
    gsuite_exporter_version = var.gsuite_exporter_version
  }
}

#--------------------#
# GSuite Exporter VM #
#--------------------#
resource "google_compute_instance" "gsuite_exporter_vm" {
  name                      = var.machine_name
  machine_type              = var.machine_type
  zone                      = var.machine_zone
  project                   = local.machine_project
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = var.machine_image
    }
  }

  network_interface {
    network = var.machine_network
    access_config {}
  }

  metadata_startup_script = data.template_file.gsuite_exporter.rendered

  service_account {
    email  = var.service_account
    scopes = ["cloud-platform"]
  }
}

#---------------------------#
# Service account IAM roles #
#---------------------------#
resource "google_project_iam_member" "token_creator" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${var.service_account}"
}

resource "google_project_iam_member" "log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${var.service_account}"
}

resource "google_project_iam_member" "log_viewer" {
  project = var.project_id
  role    = "roles/logging.viewer"
  member  = "serviceAccount:${var.service_account}"
}
