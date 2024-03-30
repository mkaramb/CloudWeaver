
resource "google_compute_network" "default" {
  name                    = var.network_prefix
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "group1" {
  name                     = "${var.network_prefix}-group1"
  ip_cidr_range            = "10.126.0.0/20"
  network                  = google_compute_network.default.self_link
  region                   = var.group1_region
  private_ip_google_access = true
}

# Router and Cloud NAT are required for installing packages from repos (apache, php etc)
resource "google_compute_router" "group1" {
  name    = "${var.network_prefix}-gw-group1"
  network = google_compute_network.default.self_link
  region  = var.group1_region
}

module "cloud-nat-group1" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 5.0"
  router     = google_compute_router.group1.name
  project_id = var.project
  region     = var.group1_region
  name       = "${var.network_prefix}-cloud-nat-group1"
}

resource "google_compute_subnetwork" "group2" {
  name                     = "${var.network_prefix}-group2"
  ip_cidr_range            = "10.127.0.0/20"
  network                  = google_compute_network.default.self_link
  region                   = var.group2_region
  private_ip_google_access = true
}

# Router and Cloud NAT are required for installing packages from repos (apache, php etc)
resource "google_compute_router" "group2" {
  name    = "${var.network_prefix}-gw-group2"
  network = google_compute_network.default.self_link
  region  = var.group2_region
}

module "cloud-nat-group2" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 5.0"
  router     = google_compute_router.group2.name
  project_id = var.project
  region     = var.group2_region
  name       = "${var.network_prefix}-cloud-nat-group2"
}

# [START cloudloadbalancing_ext_http_gce]
module "gce-lb-http" {
  source  = "terraform-google-modules/lb-http/google"
  version = "~> 10.0"
  name    = var.network_prefix
  project = var.project
  target_tags = [
    "${var.network_prefix}-group1",
    module.cloud-nat-group1.router_name,
    "${var.network_prefix}-group2",
    module.cloud-nat-group2.router_name
  ]
  firewall_networks = [google_compute_network.default.name]

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
          group = module.mig1.instance_group
        },
        {
          group = module.mig2.instance_group
        },
      ]

      iap_config = {
        enable = false
      }
    }
  }
}
# [END cloudloadbalancing_ext_http_gce]



provider "google" {
  project = var.project
}

provider "google-beta" {
  project = var.project
}

data "template_file" "group-startup-script" {
  template = file(format("%s/gceme.sh.tpl", path.module))

  vars = {
    PROXY_PATH = ""
  }
}

module "mig1_template" {
  source     = "terraform-google-modules/vm/google//modules/instance_template"
  version    = "~> 7.9"
  network    = google_compute_network.default.self_link
  subnetwork = google_compute_subnetwork.group1.self_link
  service_account = {
    email  = ""
    scopes = ["cloud-platform"]
  }
  name_prefix          = "${var.network_prefix}-group1"
  startup_script       = data.template_file.group-startup-script.rendered
  source_image_family  = "ubuntu-2004-lts"
  source_image_project = "ubuntu-os-cloud"
  tags = [
    "${var.network_prefix}-group1",
    module.cloud-nat-group1.router_name
  ]
}

module "mig1" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "~> 7.9"
  instance_template = module.mig1_template.self_link
  region            = var.group1_region
  hostname          = "${var.network_prefix}-group1"
  target_size       = var.target_size
  named_ports = [{
    name = "http",
    port = 80
  }]
  network    = google_compute_network.default.self_link
  subnetwork = google_compute_subnetwork.group1.self_link
}

module "mig2_template" {
  source     = "terraform-google-modules/vm/google//modules/instance_template"
  version    = "~> 7.9"
  network    = google_compute_network.default.self_link
  subnetwork = google_compute_subnetwork.group2.self_link
  service_account = {
    email  = ""
    scopes = ["cloud-platform"]
  }
  name_prefix    = "${var.network_prefix}-group2"
  startup_script = data.template_file.group-startup-script.rendered
  tags = [
    "${var.network_prefix}-group2",
    module.cloud-nat-group2.router_name
  ]
}

module "mig2" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "~> 7.9"
  instance_template = module.mig2_template.self_link
  region            = var.group2_region
  hostname          = "${var.network_prefix}-group2"
  target_size       = var.target_size
  named_ports = [{
    name = "http",
    port = 80
  }]
  network    = google_compute_network.default.self_link
  subnetwork = google_compute_subnetwork.group2.self_link
}
