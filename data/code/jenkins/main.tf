
locals {

  // project could be the same as var.project_id or different in case jenkins instance creating in shared VPC (means network belongs to differnet project)
  jenkins_network_project_id = coalesce(var.jenkins_network_project_id, var.project_id)

  jenkins_metadata = {
    bitnami-base-password  = local.jenkins_password
    status-uptime-deadline = 420
    startup-script         = data.template_file.jenkins_startup_script.rendered
  }

  jenkins_password = coalesce(
    var.jenkins_initial_password,
    random_string.jenkins_password.result,
  )
  jenkins_startup_script_template = file("${path.module}/templates/jenkins_startup_script.sh.tpl")
  jenkins_username                = "user"

  jenkins_workers_project_url = "https://www.googleapis.com/compute/v1/projects/${var.jenkins_workers_project_id}"

  jenkins_workers_startup_script = <<EOF
${data.template_file.jenkins_workers_agent_startup_script.rendered}
${var.jenkins_workers_startup_script}
EOF

}

resource "random_string" "jenkins_password" {
  length      = 8
  special     = "false"
  min_numeric = 1
  min_lower   = 1
  min_upper   = 1
}

data "google_compute_image" "jenkins" {
  name    = var.jenkins_boot_disk_source_image
  project = var.jenkins_boot_disk_source_image_project
}

data "google_compute_image" "jenkins_worker" {
  name    = var.jenkins_workers_boot_disk_source_image
  project = var.jenkins_workers_boot_disk_source_image_project
}

data "template_file" "jenkins_workers_agent_startup_script" {
  template = file(
    "${path.module}/templates/jenkins_workers_agent_startup_script.sh.tpl",
  )

  vars = {
    jenkins_username = local.jenkins_username
    jenkins_password = local.jenkins_password
  }
}

data "template_file" "jenkins_startup_script" {
  template = local.jenkins_startup_script_template

  vars = {
    jenkins_username                               = local.jenkins_username
    jenkins_password                               = local.jenkins_password
    jenkins_workers_project_id                     = var.jenkins_workers_project_id
    jenkins_workers_instance_cap                   = var.jenkins_workers_instance_cap
    jenkins_workers_description                    = var.jenkins_workers_description
    jenkins_workers_name_prefix                    = var.jenkins_workers_name_prefix
    jenkins_workers_region                         = "${local.jenkins_workers_project_url}/regions/${var.jenkins_workers_region}"
    jenkins_workers_zone                           = "${local.jenkins_workers_project_url}/zones/${var.jenkins_workers_zone}"
    jenkins_workers_machine_type                   = "${local.jenkins_workers_project_url}/zones/${var.jenkins_workers_zone}/machineTypes/${var.jenkins_workers_machine_type}"
    jenkins_workers_startup_script                 = local.jenkins_workers_startup_script
    jenkins_workers_preemptible                    = var.jenkins_workers_preemptible ? "true" : "false"
    jenkins_workers_min_cpu_platform               = var.jenkins_workers_min_cpu_platform
    jenkins_workers_labels                         = join(",", var.jenkins_workers_labels)
    jenkins_workers_run_as_user                    = var.jenkins_workers_run_as_user
    jenkins_workers_boot_disk_type                 = "${local.jenkins_workers_project_url}/zones/${var.jenkins_workers_zone}/diskTypes/${var.jenkins_workers_boot_disk_type}"
    jenkins_workers_boot_disk_source_image         = data.google_compute_image.jenkins_worker.self_link
    jenkins_workers_boot_disk_source_image_project = var.jenkins_workers_boot_disk_source_image_project
    jenkins_workers_network                        = var.jenkins_workers_network
    jenkins_workers_subnetwork                     = var.jenkins_workers_subnetwork
    jenkins_workers_network_tags                   = join(",", var.jenkins_workers_network_tags)
    jenkins_workers_service_account_email          = var.jenkins_workers_service_account_email
    jenkins_workers_retention_time_minutes         = var.jenkins_workers_retention_time_minutes
    jenkins_workers_launch_timeout_seconds         = var.jenkins_workers_launch_timeout_seconds
    jenkins_workers_boot_disk_size_gb              = var.jenkins_workers_boot_disk_size_gb
    jenkins_workers_num_executors                  = var.jenkins_workers_num_executors
    jobs_as_b64_json                               = base64encode(jsonencode(var.jenkins_jobs))
  }
}

resource "google_compute_instance" "jenkins" {
  project      = var.project_id
  name         = var.jenkins_instance_name
  machine_type = var.jenkins_instance_machine_type
  zone         = var.jenkins_instance_zone

  tags = var.jenkins_instance_tags

  boot_disk {
    initialize_params {
      image = data.google_compute_image.jenkins.self_link
    }
  }

  network_interface {
    subnetwork         = var.jenkins_instance_subnetwork
    subnetwork_project = local.jenkins_network_project_id

    access_config {
    }
  }

  metadata = merge(
    local.jenkins_metadata,
    var.jenkins_instance_additional_metadata,
  )

  service_account {
    email = google_service_account.jenkins.email

    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

resource "null_resource" "wait_for_jenkins_configuration" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/wait-for-jenkins.sh ${var.project_id} ${var.jenkins_instance_zone} ${var.jenkins_instance_name}"
  }

  depends_on = [google_compute_instance.jenkins]
}




resource "google_compute_firewall" "jenkins-external-80" {
  name    = "jenkins-${var.jenkins_instance_name}-external-tcp-80"
  project = local.jenkins_network_project_id
  network = var.jenkins_instance_network

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges           = var.jenkins_instance_access_cidrs
  target_service_accounts = [google_service_account.jenkins.email]
}

resource "google_compute_firewall" "jenkins-external-443" {
  name    = "jenkins-${var.jenkins_instance_name}-external-tcp-443"
  project = local.jenkins_network_project_id
  network = var.jenkins_instance_network

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges           = var.jenkins_instance_access_cidrs
  target_service_accounts = [google_service_account.jenkins.email]
}


resource "google_compute_firewall" "jenkins-external-ssh" {
  name    = "jenkins-${var.jenkins_instance_name}-external-ssh"
  project = local.jenkins_network_project_id
  network = var.jenkins_instance_network

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges           = var.jenkins_instance_access_cidrs
  target_service_accounts = [google_service_account.jenkins.email]
}

resource "google_compute_firewall" "jenkins_agent_ssh_from_instance" {
  count = var.create_firewall_rules ? 1 : 0

  name    = "jenkins-agent-ssh-access"
  network = var.jenkins_workers_network
  project = local.jenkins_network_project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_tags = var.jenkins_instance_tags
  target_tags = var.jenkins_workers_network_tags
}

resource "google_compute_firewall" "jenkins_agent_discovery_from_agent" {
  count = var.create_firewall_rules ? 1 : 0

  name    = "jenkins-agent-udp-discovery"
  network = var.jenkins_instance_network
  project = coalesce(var.jenkins_network_project_id, var.project_id)

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "tcp"
  }

  source_tags = concat(var.jenkins_instance_tags, var.jenkins_workers_network_tags)
  target_tags = concat(var.jenkins_instance_tags, var.jenkins_workers_network_tags)
}

resource "google_compute_firewall" "jenkins_agent_discovery_from_agent_workers" {
  count = var.create_firewall_rules ? 1 : 0

  name    = "jenkins-agent-udp-discovery-workers"
  network = var.jenkins_workers_network
  project = coalesce(var.jenkins_network_project_id, var.project_id)

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "tcp"
  }

  source_tags = concat(var.jenkins_instance_tags, var.jenkins_workers_network_tags)
  target_tags = concat(var.jenkins_instance_tags, var.jenkins_workers_network_tags)
}




resource "google_service_account" "jenkins" {
  project      = var.project_id
  account_id   = var.jenkins_service_account_name
  display_name = var.jenkins_service_account_display_name
}

resource "google_project_iam_member" "jenkins-instance_admin_v1" {
  project = var.project_id
  role    = "roles/compute.instanceAdmin.v1"
  member  = "serviceAccount:${google_service_account.jenkins.email}"
}

resource "google_project_iam_member" "jenkins-instance_admin" {
  project = var.project_id
  role    = "roles/compute.instanceAdmin"
  member  = "serviceAccount:${google_service_account.jenkins.email}"
}

resource "google_project_iam_member" "jenkins-network_admin" {
  project = var.project_id
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${google_service_account.jenkins.email}"
}

resource "google_project_iam_member" "jenkins-security_admin" {
  project = var.project_id
  role    = "roles/compute.securityAdmin"
  member  = "serviceAccount:${google_service_account.jenkins.email}"
}

resource "google_project_iam_member" "jenkins-service_account_actor" {
  project = var.project_id
  role    = "roles/iam.serviceAccountActor"
  member  = "serviceAccount:${google_service_account.jenkins.email}"
}

resource "google_project_iam_member" "jenkins-service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.jenkins.email}"
}

resource "google_storage_bucket_iam_member" "jenkins-upload" {
  count  = var.gcs_bucket != "" ? 1 : 0
  bucket = var.gcs_bucket
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.jenkins.email}"
}

// SharedVPC requirements
locals {
  svpc_subnets_count = var.jenkins_instance_subnetwork != var.jenkins_workers_subnetwork ? 2 : 1
}

resource "google_compute_subnetwork_iam_member" "jenkins_svpc_subnets" {
  count      = var.jenkins_network_project_id != "" ? local.svpc_subnets_count : 0
  subnetwork = element([var.jenkins_instance_subnetwork, var.jenkins_workers_subnetwork], count.index)
  role       = "roles/compute.networkUser"
  region     = var.region
  project    = var.jenkins_network_project_id
  member     = "serviceAccount:${google_service_account.jenkins.email}"
}
