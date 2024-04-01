
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = "${var.region}-a"
}

module "startup-scripts" {
  source  = "terraform-google-modules/startup-scripts/google"
  version = "~> 2.0"

  enable_setup_sudoers = true
}

data "google_compute_image" "os" {
  project = "centos-cloud"
  family  = "centos-7"
}

resource "google_compute_project_metadata" "example" {
  metadata = {
    sudoers = "example_user1,example_user2"
  }
}

resource "google_compute_instance" "example" {
  name           = "startup-scripts-example1"
  description    = "Startup Scripts Example"
  machine_type   = "f1-micro"
  can_ip_forward = false

  metadata = {
    startup-script        = module.startup-scripts.content
    startup-script-custom = file("${path.module}/files/startup-script-custom")
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }

  boot_disk {
    auto_delete = true

    initialize_params {
      image = data.google_compute_image.os.self_link
      type  = "pd-standard"
    }
  }

  network_interface {
    network = var.network

    access_config {
      // Ephemeral IP
    }
  }
}
