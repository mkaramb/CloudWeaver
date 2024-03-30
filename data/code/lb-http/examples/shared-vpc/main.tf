
provider "google" {
  project = var.service_project
  region  = var.region
}

provider "google-beta" {
  project = var.service_project
  region  = var.region
}

# [START cloudloadbalancing_ext_http_gce_shared_vpc]
module "gce-lb-http" {
  source  = "terraform-google-modules/lb-http/google"
  version = "~> 10.0"

  name              = "group-http-lb"
  project           = var.service_project
  target_tags       = ["allow-shared-vpc-mig"]
  firewall_projects = [var.host_project]
  firewall_networks = [var.network]

  backends = {
    default = {
      protocol    = "HTTP"
      port        = 80
      port_name   = "http"
      timeout_sec = 10
      enable_cdn  = false

      health_check = {
        request_path = "/"
        port         = 80
      }

      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      groups = [
        {
          group = module.mig.instance_group
        }
      ]

      iap_config = {
        enable = false
      }
    }
  }
}
# [END cloudloadbalancing_ext_http_gce_shared_vpc]



data "template_file" "group-startup-script" {
  template = file(format("%s/gceme.sh.tpl", path.module))

  vars = {
    PROXY_PATH = ""
  }
}

resource "google_compute_network" "default" {
  name                    = var.network
  auto_create_subnetworks = "false"
  project                 = var.host_project
}

resource "google_compute_subnetwork" "default" {
  name                     = var.subnetwork
  ip_cidr_range            = "10.127.0.0/20"
  network                  = google_compute_network.default.self_link
  region                   = var.region
  project                  = var.host_project
  private_ip_google_access = true
}

resource "google_compute_router" "default" {
  name    = "lb-http-router"
  network = google_compute_network.default.self_link
  region  = var.region
  project = var.host_project
}

module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 5.0"
  router     = google_compute_router.default.name
  project_id = var.host_project
  region     = var.region
  name       = "cloud-nat-lb-http-router"
}

module "mig_template" {
  source             = "terraform-google-modules/vm/google//modules/instance_template"
  version            = "~> 7.9"
  network            = google_compute_network.default.self_link
  subnetwork         = var.subnetwork
  subnetwork_project = var.host_project
  service_account = {
    email  = ""
    scopes = ["cloud-platform"]
  }
  name_prefix    = "shared-vpc-mig"
  startup_script = data.template_file.group-startup-script.rendered
  tags           = ["allow-shared-vpc-mig"]
}

module "mig" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "~> 7.9"
  instance_template = module.mig_template.self_link
  region            = var.region
  hostname          = var.network
  target_size       = 2
  named_ports = [{
    name = "http",
    port = 80
  }]
  network    = google_compute_network.default.self_link
  subnetwork = google_compute_subnetwork.default.self_link
}
